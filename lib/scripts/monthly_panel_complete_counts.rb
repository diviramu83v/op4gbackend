# frozen_string_literal: true

# If we're running this in May 2020, we want >= April 1, 2020 and < May 1, 2020.

starting = (Time.zone.today - 1.month).at_beginning_of_month
puts starting

ending = Time.zone.today.at_beginning_of_month
puts ending

puts Onboarding
  .complete
  .where('survey_finished_at >= ? AND survey_finished_at < ?', starting, ending)
  .where.not(panelist: nil)
  .count
