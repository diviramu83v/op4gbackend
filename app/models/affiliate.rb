# frozen_string_literal: true

# These are affiliates
class Affiliate < ApplicationRecord
  include RecruitmentSourceReport
  include RecruitingStats
  include LifecycleStats
  include PanelistNetProfit
  include CompletesFunnel

  validates :code, presence: true
  has_many :panelists, primary_key: 'code', foreign_key: 'affiliate_code', inverse_of: :affiliate, dependent: :restrict_with_exception
  has_many :onboardings, through: :panelists
  has_many :onramps, through: :onboardings
  has_many :surveys, through: :onramps
  has_many :conversions, dependent: :restrict_with_exception

  after_create_commit :start_query_affiliate_name_job

  def start_query_affiliate_name_job
    QueryAffiliateNameJob.perform_later(self)
  end

  def update_name_from_api
    @tune_api = TuneApi.new
    affiliate_name = @tune_api.query_affiliate_name(code: code)
    update!(name: affiliate_name)
  end

  def code_and_name
    "#{code}: #{name}"
  end

  def self.pull_report_data(start_period, end_period, current_user_id)
    @records = AffiliateReportData.new(start_period: start_period, end_period: end_period).records
    html = ApplicationController.render(
      partial: 'employee/affiliate_reports/table_data',
      locals: { records: @records }
    )
    AffiliateReportChannel.broadcast_to(current_user_id, html)
  end

  # def surveys
  #   @surveys ||= onboardings.select(:onramp_id).distinct.map(&:survey)
  # end
end
