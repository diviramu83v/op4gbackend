# frozen_string_literal: true

# 1 argument: date, takes the first day of a month and shows all records for that month
# Usage: rails runner lib/scripts/reports/create_earnings_and_payments_file.rb 2021-03-01 > ~/Downloads/earnings_and_payments.csv

include ApplicationHelper

date = ARGV[0].to_date

def earnings_and_payments(date)
  Earning.where(created_at: date.all_month) + Payment.where(created_at: date.all_month)
end

puts 'panelist_id,email,panelist_name,panelist_status,join_date,transaction_time,period,category,work_order,description,personal_total,nonprofit_total,nonprofit_name'

earnings_and_payments(date).each do |transaction| # rubocop:disable Metrics/BlockLength
  category = transaction.instance_of?(Earning) && transaction.sample_batch.present? ? 'Credit: survey earning' : transaction.ledger_description
  work_order = transaction.instance_of?(Earning) ? transaction.project&.work_order : nil
  description =
    if transaction.instance_of?(Earning)
      transaction.onboarding.present? ? "Survey Credit: #{transaction.onboarding.survey.name}" : 'Earning'
    else
      transaction.description || 'Payout'
    end
  personal_amount = transaction.instance_of?(Earning) ? number_to_currency(transaction.panelist_amount) : "-#{number_to_currency(transaction.amount)}"
  nonprofit_amount = transaction.instance_of?(Earning) ? number_to_currency(transaction.nonprofit_amount) : nil
  nonprofit_name = transaction.instance_of?(Earning) ? transaction.nonprofit&.name : nil
  row = [
    transaction.panelist.id,
    transaction.panelist.email,
    transaction.panelist.name.gsub(',', ''),
    transaction.panelist.status,
    transaction.panelist.created_at.strftime('%Y-%m-%d'),
    transaction.created_at.strftime('%Y-%m-%d %H:%M'),
    transaction.period,
    category,
    work_order,
    description.gsub(',', ''),
    personal_amount,
    nonprofit_amount,
    nonprofit_name&.gsub(',', '')
  ]

  puts row.join(',')
end
