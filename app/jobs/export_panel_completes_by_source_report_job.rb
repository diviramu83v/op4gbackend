# frozen_string_literal: true

# export data for panel completes report
class ExportPanelCompletesBySourceReportJob < ApplicationJob
  queue_as :ui

  def perform(current_user, month, year) # rubocop:disable Metrics/MethodLength
    csv_file = CSV.generate do |csv|
      csv << ['Source', 'Complete count']
      onboardings_by_source(month, year).sort_by { |_k, v| -v }.each do |source, count|
        csv << [source || 'No source', count]
      end
    end
    PanelCompletesBySourceDownloadChannel.broadcast_to(
      current_user,
      csv_file: {
        file_name: "panel_completes_by_source_for_#{month}_#{year}.csv",
        content: csv_file
      }
    )
  end

  private

  def onboardings_by_source(month, year)
    onboarding_by_source = onboardings(month, year).group_by { |onboarding| onboarding.panelist&.recruiting_source_name }
    onboarding_by_source.each_with_object(Hash.new(0)) do |(k, _v), h|
      h[k] = onboarding_by_source[k].count
    end
  end

  def onboardings(month, year)
    date = DateTime.new(year.to_i, Date::MONTHNAMES.index(month))
    Onboarding.where('onboardings.created_at BETWEEN ? and ?', date.beginning_of_month, date.end_of_month).where.not(panelist_id: nil).complete
  end
end
