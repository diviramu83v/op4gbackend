# frozen_string_literal: true

# 1 argument: number_of_days
# Usage: rails runner lib/scripts/print_flagged_counts.rb 30

number_of_days = ARGV[0].to_i

def print_batch(onboardings)
  batch_count = onboardings.count

  categories = onboardings.find_each.map do |onboarding|
    if onboarding.marked_fraud_at.present?
      'flagged'
    else
      'passed'
    end
  end
  grouped_categories = categories.uniq.map { |s| [s, categories.count(s)] }

  grouped_categories.sort_by(&:last).reverse.each do |key, value|
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
