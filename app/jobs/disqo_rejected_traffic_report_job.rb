# frozen_string_literal: true

# export data for rejected Disqo traffic
class DisqoRejectedTrafficReportJob < ApplicationJob
  include ApplicationHelper
  queue_as :ui

  def perform(month, year, current_user) # rubocop:disable Metrics:AbcSize
    removed_onboardings = onboardings_with_rejected_disqo_quotas(month, year)
    csv_file = CSV.generate do |csv|
      csv << ['PM Name', 'Op4G Admin ID', 'Disqo Quota ID', 'Removed UID', 'Rejected Reason', 'Today\'s Date', 'Payout']
      removed_onboardings.find_each do |onboarding|
        pm_name = onboarding.project.manager.name
        admin_id = onboarding.project.id
        quota_id = onboarding.disqo_quota.quota_id
        uid = onboarding.uid
        removal_reason = onboarding.rejected_reason
        date = Time.now.utc.strftime('%m-%d-%Y')
        payout = number_to_currency(onboarding.disqo_quota.cpi)
        csv << [pm_name, admin_id, quota_id, uid, removal_reason, date, payout]
      end
    end
    DisqoRejectedTrafficReportChannel.broadcast_to(
      current_user,
      csv_file: {
        file_name: file_name(month, year),
        content: csv_file
      }
    )
  end

  private

  def onboardings_with_rejected_disqo_quotas(month, year)
    date = "#{month} #{year}".to_datetime
    Onboarding.where(created_at: date.all_month).where(client_status: 'rejected').joins(:disqo_quota)
  end

  def file_name(month, year)
    "Rejected Disqo traffic from #{month} #{year}.csv"
  end
end
