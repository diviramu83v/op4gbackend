# frozen_string_literal: true

# Helps calculate the strings we use to represent our financial periods.
class PeriodCalculator
  def self.current_period
    Time.now.utc.strftime('%Y-%m')
  end

  def self.current_period_year
    Time.now.utc.strftime('%Y')
  end

  # rubocop:disable Metrics/MethodLength
  def self.current_quarter_periods
    now = Time.now.utc
    month = now.strftime('%m').to_i
    year = now.strftime('%Y')

    case month
    when 1..3
      ["#{year}-01", "#{year}-02", "#{year}-03"]
    when 4..6
      ["#{year}-04", "#{year}-05", "#{year}-06"]
    when 7..9
      ["#{year}-07", "#{year}-08", "#{year}-09"]
    when 10..12
      ["#{year}-10", "#{year}-11", "#{year}-12"]
    end
  end
  # rubocop:enable Metrics/MethodLength

  def self.monthly_periods
    (0..2).each_with_object([]) do |year_ago, array|
      (0..11).each do |month_ago|
        new_time = Time.now.utc - year_ago.years
        new_time = (new_time - month_ago.months).beginning_of_month
        array << [new_time.strftime('%Y-%m'), new_time]
      end
    end
  end
end
