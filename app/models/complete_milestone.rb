# frozen_string_literal: true

# Represents a geographic division of the United States.
class CompleteMilestone < ApplicationRecord
  enum status: {
    active: 'active',
    inactive: 'inactive',
    sent: 'sent'
  }

  belongs_to :survey
  has_one :project, through: :survey

  validates :status, presence: true
  validate :milestone_target_is_greater_than_current_completes, on: :create

  after_create :deactivate_previous_milestone

  def mark_as_deactivated
    update(status: CompleteMilestone.statuses[:inactive])
  end

  def mark_as_sent
    update(status: CompleteMilestone.statuses[:sent], sent_at: Time.now.utc)
  end

  def milestone_target_is_greater_than_current_completes
    return if target_completes > survey.adjusted_complete_count

    errors.add(:base, 'Milestone has to be higher than the current complete count')
  end

  def deactivate_previous_milestone
    return if survey.complete_milestones.active.count == 1

    survey.complete_milestones.active.second_to_last.update!(status: CompleteMilestone.statuses[:inactive])
  end

  def target_reached?
    target_completes <= survey.adjusted_complete_count
  end

  def send_milestone_email
    EmployeeMailer.survey_milestone_reached(project.manager, self).deliver_later
    mark_as_sent
  end
end
