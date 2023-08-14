# frozen_string_literal: true

# This class helps organize and report on traffic data by week.
class ProjectWeek
  include TrafficCalculations

  def initialize(starting:, ending:, source: nil)
    @starting = starting
    @ending = ending
    @source = source
  end

  attr_reader :starting, :ending

  def code
    @starting.strftime('%Gwk%V')
  end

  def clean_id_errors
    clean_id_result_checks.select do |check|
      contains_error?(check)
    end
  end

  # rubocop:disable Metrics/MethodLength
  def self.most_recent(count, source: nil)
    start_of_week = count.weeks.ago.beginning_of_week

    results = []

    while start_of_week < Time.now.utc.beginning_of_week
      results << ProjectWeek.new(
        starting: start_of_week,
        ending: start_of_week.end_of_week,
        source: source
      )

      start_of_week += 1.week
    end

    results
  end
  # rubocop:enable Metrics/MethodLength

  private

  def traffic_records
    @traffic_records ||= if @source.present?
                           traffic_records_from_source
                         else
                           Onboarding.live.where('onboardings.created_at between ? and ?', @starting, @ending)
                         end
  end

  def traffic_records_from_source
    if @source.is_a?(Vendor)
      if @source.api_tokens.present?
        Onboarding.live.where('onboardings.created_at between ? and ?', @starting, @ending).for_api_vendor(@source)
      else
        Onboarding.live.where('onboardings.created_at between ? and ?', @starting, @ending).for_batch_vendor(@source)
      end
    else
      Onboarding.live.where(panel: @source).where('onboardings.created_at between ? and ?', @starting, @ending)
    end
  end

  def traffic_checks
    TrafficCheck.where('traffic_checks.created_at between ? and ?', @starting, @ending)
  end

  # rubocop:disable Metrics/MethodLength
  def clean_id_result_checks
    traffic_checks.joins(:traffic_step)
                  .where(
                    traffic_steps: {
                      category: 'clean_id'
                    }
                  )
                  .where(
                    traffic_checks: {
                      controller_action: 'show'
                    }
                  )
                  .order(:id)
  end
  # rubocop:enable Metrics/MethodLength

  def contains_error?(check)
    return false if check.data_collected.key?('forensic')
    return true if check.data_collected.key?('error')
  rescue NoMethodError
    return false if check.data_collected.nil?

    JSON.parse(check.data_collected).key?('error')
  end
end
