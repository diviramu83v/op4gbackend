# frozen_string_literal: true

# export data for block rate by source report
class ExportBlockRateBySourceReportJob < ApplicationJob
  include ApplicationHelper
  queue_as :ui

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/BlockLength
  def perform(current_user, params)
    start_time = params['start_date'].to_datetime.strftime('%Y/%m/%d')
    end_time = params['end_date'].to_datetime.strftime('%Y/%m/%d')
    csv_file = CSV.generate do |csv|
      csv << ['Source', 'Total Traffic Records', 'Total Blocked', 'Block Rate', 'CleanID: no data', 'CleanID: not unique',
              'CleanID: OR score too high', 'CleanID: score missing', 'CleanID: took too long', 'failed: IP inconsistent', 'IP inconsistent',
              'failed: Some steps incomplete', 'Recaptcha: check failed', 'Recaptcha: repeat visit', 'Recaptcha: took too long']
      request_source = params['source'].presence || nil
      all_records = onboardings_from_time_period(start_time, end_time)
      grouped_data = build_hash(all_records, request_source)
      grouped_data.each do |source, data|
        block_count = data['blocked_count']
        errors = data['errors'].tally
        count = data['count']
        block_percentage = calculate_percentage(block_count.to_f, count)
        csv << [source, format_number(count.to_i), format_number(block_count.to_i), format_percentage(block_percentage), errors['CleanID: no data'],
        errors['CleanID: not unique'], errors['CleanID: OR score too high'], errors['CleanID: score missing'], errors['CleanID: took too long'], errors['failed: IP inconsistent'],
        errors['IP inconsistent'], errors['failed: Some steps incomplete'], errors['Recaptcha: check failed'], errors['Recaptcha: repeat visit'], errors['Recaptcha: took too long']
        ]
      end
    end

    BlockRateBySourceReportDownloadChannel.broadcast_to(
      current_user,
      csv_file: {
        file_name: "block_rate_by_source_report_for_#{start_time}_to_#{end_time}.csv",
        content: csv_file
      }
    )
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Metrics/BlockLength

  private

  def calculate_percentage(numerator, denominator)
    return 0 if denominator.zero?

    (numerator / denominator) * 100
  end

  def build_hash(onboardings, source=nil)
    results = {}

    onboardings.find_each do |onboarding|
      source_name = combined_source_name(onboarding)
      next if source && source_name.downcase != source.downcase
      if results[source_name].blank?
        results[source_name] = {}
        results[source_name]['count'] = 1
        results[source_name]['blocked_count'] = 0
        results[source_name]['errors'] = []
      else
        results[source_name]['count'] += 1
      end
      if onboarding.blocked?
        results[source_name]['blocked_count'] += 1
        results[source_name]['errors'] << onboarding.error_message
      end
    end

    results
  end

  def combined_source_name(onboarding)
    source_name = onboarding.source_name
    if source_name&.include?('Disqo')
      'Disqo'
    elsif source_name&.include?('Cint')
      'Cint'
    else
      source_name
    end
  end

  def onboardings_from_time_period(start_time, end_time)
    onboardings = Onboarding.where(created_at: start_time..end_time).includes([:panel, :api_vendor, :batch_vendor, :cint_survey, :disqo_quota, onramp: :panel, survey: :disqo_quotas])
  end
end
