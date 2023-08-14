# frozen_string_literal: true

# Traffic details from a survey
class TrafficReport < ApplicationRecord
  has_attached_file :report, Rails.configuration.paperclip_traffic_reports

  belongs_to :survey, optional: true
  has_one :project, through: :survey

  do_not_validate_attachment_file_type :report
  validates_attachment :report, attachment_presence: true

  after_create :build_report
  after_create_commit :broadcast

  private

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def build_report
    data = case report_type
           when 'all-traffic'
             survey.onboardings.most_recent_first.to_csv
           when 'completes'
             survey.onboardings.live.complete.most_recent_first.to_csv
           else
             raise 'Unexpected traffic report type.'
           end

    self.report = StringIO.new(data.to_s)
    report.instance_write(:content_type, 'text/csv')
    report.instance_write(:file_name, filename)

    save!
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  def filename
    "#{project.id}-#{survey.name}-#{report_type}.csv"
  end

  def broadcast
    TrafficReportsChannel.broadcast_to('all', report_type)
  end
end
