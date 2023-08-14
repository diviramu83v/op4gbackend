# frozen_string_literal: true

# A demographic detail is a record used to look up a panelist's demographic data.
class DemographicDetail < ApplicationRecord
  has_many :demographic_detail_results, dependent: :destroy
  has_many :panelists, through: :demographic_detail_results

  belongs_to :panel

  before_validation :set_panel
  validate :records_belong_to_same_panel?

  after_create :process_results

  def separate_upload_data
    upload_data.split(/\n/).map(&:strip).compact_blank
  end

  def records_belong_to_same_panel?
    panel_ids = separate_upload_data.map do |data|
      record = find_record(data)
      record.is_a?(Panelist) ? record&.primary_panel&.id : record&.panel&.id
    end

    errors.add(:base, 'Multiple panels found.') if panel_ids.uniq.count > 1
  end

  def set_panel
    record = find_record(separate_upload_data.first)
    self.panel = record.is_a?(Panelist) ? record&.primary_panel : record&.panel
  end

  def process_results
    separate_upload_data.each do |data|
      record = find_record(data)
      next if record.blank?

      panelist = record.is_a?(Panelist) ? record : record.panelist
      next if panelist.blank?

      create_result(data, panelist)
    end
  end

  def create_result(data, panelist)
    DemographicDetailResult.create!(
      uid: data,
      demographic_detail: self,
      panelist: panelist
    )
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def to_csv
    CSV.generate do |csv|
      panel_questions = %w[id age]
      panel.demo_questions.each do |question|
        panel_questions << question.body
      end

      csv << panel_questions

      answers = %w[]
      panelists.each do |panelist|
        answers += [panelist.demographic_detail_results.find_by(demographic_detail: self).uid, panelist.age]
        panel.demo_questions.each do |panel_question|
          panelist.demo_answers.each do |answer|
            answers << answer.demo_option.label if answer.demo_question == panel_question
          end
        end
        csv << answers
        answers = %w[]
      end
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  def find_record(data)
    Onboarding.find_by(token: data) || Onboarding.find_by(uid: data) || Panelist.find_by(email: data)
  end
end
