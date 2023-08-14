# frozen_string_literal: true

# 1 argument: number_of_days
# Usage: rails runner lib/scripts/count_id_batches_by_traffic_source.rb 30

number_of_days = ARGV[0].to_i

def print_batch(onboardings)
  batch_count = onboardings.count
  sources = onboardings.find_each.map(&:source_name)
  grouped_sources = sources.uniq.map { |s| [s, sources.count(s)] }

  grouped_sources.sort_by(&:last).reverse.each do |key, value|
    puts "#{key}: #{value} (#{(value.to_f / batch_count * 100).round(2)}%)"
  end
end

fraud = Onboarding.fraudulent.where('created_at >= ?', number_of_days.days.ago)
puts 'FRAUD'
print_batch(fraud)
puts

rejected = Onboarding.rejected.where('created_at >= ?', number_of_days.days.ago)
puts 'REJECTED'
print_batch(rejected)
puts

accepted = Onboarding.accepted.where('created_at >= ?', number_of_days.days.ago)
puts 'ACCEPTED'
print_batch(accepted)
puts
