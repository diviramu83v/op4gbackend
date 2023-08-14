# frozen_string_literal: true

# 1 argument: number_of_days
# usage: rails runner lib/scripts/compare_fraud_accepted_ids_by_time_elapsed_on_traffic_steps.rb 10

start_script = Time.zone.now
number_of_days = ARGV[0].to_i

accepted_onboardings = Onboarding.joins(:onramp).where(onramps: { check_clean_id: true }).accepted.where('onboardings.created_at >= ?', number_of_days.days.ago)
fraudulent_onboardings = Onboarding.joins(:onramp).where(onramps: { check_clean_id: true }).fraudulent.where('onboardings.created_at >= ?', number_of_days.days.ago)
rejected_onboardings = Onboarding.joins(:onramp).where(onramps: { check_clean_id: true }).rejected.where('onboardings.created_at >= ?', number_of_days.days.ago)

def calculate_percentage(part, whole)
  ((part / whole.to_f) * 100).round(1)
end

def format_when(traffic_step_category, pre_or_post)
  traffic_step_category == 'clean_id' ? "(#{pre_or_post})" : ''
end

def get_threshold(traffic_step_category)
  if traffic_step_category == 'clean_id'
    ceiling = 12
    floor = 1
    decrement = 1
  else
    ceiling = 480
    floor = 240
    decrement = 30
  end
  [ceiling, floor, decrement]
end

def average_time_elapsed(onboardings, traffic_step_category, pre_or_post, threshold)
  onboardings_count = 0
  allow_count = 0
  total_time_elapsed = 0.0

  onboardings.find_each do |onboarding|
    next unless onboarding.traffic_steps.where(category: traffic_step_category).any?

    onboarding.traffic_steps.where(category: traffic_step_category, when: pre_or_post).each do |traffic_step|
      next unless traffic_step.traffic_checks.size > 1

      onboardings_count += 1
      total_time_elapsed += traffic_step.elapsed_time
      allow_count += 1 if traffic_step.elapsed_time < threshold
    end
  end
  [allow_count, onboardings_count, total_time_elapsed / onboardings_count]
end

def process(onboardings, traffic_step_category, pre_or_post, title)
  ceiling = get_threshold(traffic_step_category)[0]
  floor = get_threshold(traffic_step_category)[1]
  decrement = get_threshold(traffic_step_category)[2]

  i = ceiling
  while i >= floor
    results = average_time_elapsed(onboardings, traffic_step_category, pre_or_post, i)
    if i == ceiling
      puts "#{title.upcase} / #{traffic_step_category.humanize(keep_id_suffix: true).upcase} #{format_when(traffic_step_category, pre_or_post)}"
      puts
      puts "Record count: #{results[1]}"
      puts "#{traffic_step_category.humanize(keep_id_suffix: true)} #{format_when(traffic_step_category, pre_or_post)} average time: #{results[2].round(2)}s"
      puts
    end
    puts "#{traffic_step_category.humanize(keep_id_suffix: true)} #{format_when(traffic_step_category, pre_or_post)} #{i}s: " \
         "block #{100 - calculate_percentage(results[0], results[1])}% / allow #{calculate_percentage(results[0], results[1])}%"
    puts if i == floor
    i -= decrement
  end
end

process(accepted_onboardings, 'clean_id', 'pre', 'accepted')
process(accepted_onboardings, 'clean_id', 'post', 'accepted')
process(accepted_onboardings, 'recaptcha', 'pre', 'accepted')

process(fraudulent_onboardings, 'clean_id', 'pre', 'fraudulent')
process(fraudulent_onboardings, 'clean_id', 'post', 'fraudulent')
process(fraudulent_onboardings, 'recaptcha', 'pre', 'fraudulent')

process(rejected_onboardings, 'clean_id', 'pre', 'rejected')
process(rejected_onboardings, 'clean_id', 'post', 'rejected')
process(rejected_onboardings, 'recaptcha', 'pre', 'rejected')

puts "Run time: #{(Time.zone.now - start_script).to_i} seconds"
