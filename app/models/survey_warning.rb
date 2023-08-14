# frozen_string_literal: true

# A survey warning warns a user of a query that hasn't been filtered
class SurveyWarning < ApplicationRecord
  enum category: {
    query_has_no_filters: 'query_has_no_filters',
    unsent_batches: 'unsent_batches'
  }

  enum status: {
    active: 'active',
    inactive: 'inactive'
  }

  validates :status, :category, presence: true

  belongs_to :survey
  belongs_to :sample_batch, optional: true

  has_one :project, through: :survey
  has_one :project_manager, through: :project, source: :manager

  def mark_as_inactive
    update(status: SurveyWarning.statuses[:inactive])
  end

  def self.project_managers
    active.joins(:project_manager).order('employees.last_name').map(&:project_manager).uniq
  end

  def self.create_warnings_for_live_projects_with_unsent_batches
    Survey.live.find_each do |survey|
      next unless survey.needs_missing_batch_warning?

      survey.sample_batches.unsent.find_each do |batch|
        survey.survey_warnings.create!(
          category: 'unsent_batches',
          status: 'active',
          sample_batch: batch
        )
      end
    end
  end

  def self.check_batch(sample_batch)
    return if sample_batch.query.filtered?
    return if sample_batch.survey.survey_warnings.query_has_no_filters.any?

    sample_batch.survey_warnings.create(
      category: SurveyWarning.categories[:query_has_no_filters],
      status: SurveyWarning.statuses[:active],
      survey: sample_batch.survey
    )
  end
end
