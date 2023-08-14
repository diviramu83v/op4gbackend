# frozen_string_literal: true

# 1 argument: panel_id
# usage: rails runner lib/scripts/pull_data_on_deactivated_panelists.rb 50 > ~/Downloads/deactivated-panelist-data.csv

def format_recruiting_source(source)
  source.split(',').first
end

def format_income(income)
  income.delete(',')
end

def full_name(panelist)
  "#{panelist.first_name} #{panelist.last_name}"
end

panel_id = ARGV[0].to_i

puts 'Name,Email,Panel,Recruiting Source,Deactivation Date,Employment Status,Job Title,Industry,Income Level,Lifetime Payouts Count,Lifetime Net Profit'

# rubocop:disable Metrics/BlockLength
Panelist.deactivated.where(primary_panel_id: panel_id).each do |panelist|
  employment_question = panelist.demo_questions.find_by(body: 'What is your current employment status?')
  employment_question = panelist.demo_questions.find_by(body: 'What is your employment status?') if employment_question.nil?
  employment_option = panelist.demo_options.find_by(demo_question: employment_question)

  job_title_question = panelist.demo_questions.find_by(body: 'What is your job title?')
  job_title_question = panelist.demo_questions.find_by(body: 'Which best describes your job title?') if job_title_question.nil?
  job_title_option = panelist.demo_options.find_by(demo_question: job_title_question)

  income_question = panelist.demo_questions.find_by(body: 'What is your annual household income?')
  income_question = panelist.demo_questions.find_by(body: 'What is your total annual household income, before taxes?') if income_question.nil?
  income_option = panelist.demo_options.find_by(demo_question: income_question)

  industry_question = panelist.demo_questions.find_by(body: 'Which best describes the organization or industry in which you work?')
  industry_question = panelist.demo_questions.find_by(body: 'What industry do you work in professionally?') if industry_question.nil?
  industry_question = panelist.demo_questions.find_by(body: 'What industry do you work in?') if industry_question.nil?
  industry_option = panelist.demo_options.find_by(demo_question: industry_question)

  row = [
    full_name(panelist),
    panelist.email,
    panelist.primary_panel.name,
    panelist.recruiting_source.present? ? format_recruiting_source(panelist.recruiting_source.name) : ' ',
    panelist.deactivated_at.strftime('%m/%d/%Y'),
    employment_option.present? ? employment_option.label : ' ',
    job_title_option.present? ? job_title_option.label : ' ',
    industry_option.present? ? industry_option.label : ' ',
    income_option.present? ? format_income(income_option.label) : ' ',
    panelist.payments.count,
    panelist.net_profit
  ]

  puts row.join(',')
end
# rubocop:enable Metrics/BlockLength
