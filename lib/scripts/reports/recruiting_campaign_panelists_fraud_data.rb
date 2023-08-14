# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

# Usage: rails runner lib/scripts/reports/recruiting_campaign_panelists_fraud_data.rb <campaign_code1> <campaign_code2> > ~/Downloads/recruiting_campaign_panelists_fraud_report.csv

# Recent production example:
# heroku run -r production rails runner lib/scripts/reports/recruiting_campaign_panelists_fraud_data.rb elliam-fdm-doi elliam-sbo-doi elliam-contractors elliam-hhi elliam-fdm elliam-sbo elliam-zeel > ~/Downloads/recruiting_campaign_panelists_fraud_report.csv

def find_age(panelist)
  panelist.age
end

def find_gender(panelist)
  question = panelist.demo_questions.where(body: 'What is your gender?').first
  panelist.demo_answers.joins(:demo_option).where('demo_options.demo_question_id' => question.id).first.demo_option.label
end

def find_income(panelist)
  question = panelist.demo_questions.where(body: 'What is your total annual household income, before taxes?').first
  panelist.demo_answers.joins(:demo_option).where('demo_options.demo_question_id' => question.id).first.demo_option.label
end

def find_first_invitation_date(panelist)
  return if panelist.invitations.has_been_sent.count.zero?

  panelist.invitations.has_been_sent.order(:created_at).first.sent_at
end

def find_last_invitation_date(panelist)
  return if panelist.invitations.has_been_sent.count.zero?

  panelist.invitations.has_been_sent.order(:created_at).last.sent_at
end

def find_number_of_completes(panelist)
  panelist.onboardings.complete.count
end

codes = ARGV

puts 'Email,Campaign,Created,Panel,Status,DOI?,Demos completed?,Invitation count,Invitation clicks,CleanID Fraud Score,CleanID Event Unique?,Country,State,First name,Last name,Unique ID,Age,Gender,Income,First Invitation,Last Invitation,Number of completes'

codes.each do |code|
  campaign = RecruitingCampaign.find_by(code: code)

  campaign.panelists.active.each do |panelist|
    email = panelist.email
    campaign = panelist.campaign.code
    created = panelist.created_at
    panel = Panel.find(panelist.primary_panel_id)
    status = panelist.status
    doi = panelist.confirmed_at.present?
    demos = panelist.welcomed_at.present?
    invitation_count = panelist.invitations.has_been_sent.count
    invitation_clicks = panelist.invitations.has_been_clicked.count
    fname = panelist.first_name
    lname = panelist.last_name
    token = panelist.token

    age = find_age(panelist)
    gender = find_gender(panelist)
    income = find_income(panelist)
    first_invitation_date = find_first_invitation_date(panelist)
    last_invitation_date = find_last_invitation_date(panelist)
    number_of_completes = find_number_of_completes(panelist)

    data = panelist.clean_id_data
    data.is_a?(String) ? {} : data

    if data.present?
      score = data.dig('forensic', 'marker', 'score')
      unique = data.dig('forensic', 'unique', 'isEventUnique')
      country = data.dig('forensic', 'geo', 'countryCode')
      state = data.dig('forensic', 'geo', 'stateProvince')
    else
      score = 'N/A'
      unique = 'N/A'
      country = 'N/A'
      state = 'N/A'
    end

    puts "\"#{email}\",\"#{campaign}\",\"#{created}\",\"#{panel.slug}\",\"#{status}\",\"#{doi}\",\"#{demos}\",\"#{invitation_count}\",\"#{invitation_clicks}\",\"#{score}\",\"#{unique}\",\"#{country}\",\"#{state}\",\"#{fname}\",\"#{lname}\",\"#{token}\",\"#{age}\",\"#{gender}\",\"#{income}\",\"#{first_invitation_date}\",\"#{last_invitation_date}\",\"#{number_of_completes}\""
  end
end
# rubocop:enable Metrics/BlockLength
