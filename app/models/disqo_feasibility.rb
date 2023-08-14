# frozen_string_literal: true

# this is for the Disqo API's Quota Feasibilities
class DisqoFeasibility < ApplicationRecord
  include DisqoQuotaQualifications

  belongs_to :employee

  validates :loi, :completes_wanted, :days_in_field, :incidence_rate, presence: true
  validates :loi, numericality: { less_than: 30 }
  validate :number_of_panelists_is_present

  before_validation :calculate_cpi
  before_validation :create_disqo_feasibility

  scope :most_recent, -> { order('created_at DESC') }

  def create_disqo_feasibility
    response = DisqoApi.new.create_quota_feasibility(body: DisqoApiPayload.new(disqo_object: self).feasibility_project_body.to_json)
    return unless response.code == 200

    self.number_of_panelists = response&.dig('project', 'quotas')&.first&.dig('numberOfPanelists')
  end

  def calculate_cpi
    self.cpi = CpiCalculator.new(loi: loi, incidence_rate: incidence_rate).calculate!
  end

  FORM_FIELDS = %w[
    householdincome
    ethnicity
    employmentstatus
    jobposition
    employeecount
    industry
    educationlevel
    rentorown
    groceryshoppingduty
    children
  ].freeze

  private

  def number_of_panelists_is_present
    errors.add(:base, 'Unable to create disqo feasibility') if number_of_panelists.blank?
  end
end
