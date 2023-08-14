# frozen_string_literal: true

# usage: rails runner lib/scripts/pull_roi_data.rb > ~/Downloads/roi.csv

def print_traffic_record(traffic, source)
  source_type = source.is_a?(RecruitingCampaign) ? 'campaign' : 'offer'
  source_code = source.code

  parent_type, parent_name = if source.is_a?(RecruitingCampaign)
                               if source.campaignable.present?
                                 ['nonprofit', source.campaignable.name]
                               else
                                 ['one-off campaign', source.code]
                               end
                             else
                               ['affiliate', traffic&.panelist&.affiliate&.name]
                             end

  panelist_id = traffic.panelist.id
  email = traffic.panelist.email
  client_status = traffic.client_status

  survey_year = traffic.survey_finished_at.year # report based on survey activity
  recruitment_year = traffic.panelist.welcomed_at.year # report based on panelist recruitment

  # date = traffic.survey_finished_at # report based on survey activity
  # date = traffic.panelist.welcomed_at # report based on panelist recruitment

  # year = date.year
  # month = "#{date.year}-#{date.month.to_s.rjust(2, '0')}"
  # quarter = case month[-2..-1].to_i
  #           when 1..3
  #             "#{date.year}-01"
  #           when 4..6
  #             "#{date.year}-02"
  #           when 7..9
  #             "#{date.year}-03"
  #           when 9..12
  #             "#{date.year}-04"
  #           end
  # week = "#{date.year}-#{date.strftime('%-V').rjust(2, '0')}"

  cpi = traffic.survey.cpi
  earnings = traffic&.earning&.total_amount || 0.0
  profit = cpi - earnings

  puts "\"#{source_type}\",\"#{source_code}\",\"#{parent_type}\",\"#{parent_name}\",\"#{client_status}\",\"#{panelist_id}\",\"#{email}\",\"#{recruitment_year}\",\"#{survey_year}\",\"#{cpi}\",\"#{earnings}\",\"#{profit}\""
end
puts 'source type,source,parent type,parent,client status,panelist ID,panelist email,recruitment year,survey year,earned,paid,profit'

RecruitingCampaign.find_each do |campaign|
  traffic = Onboarding.complete
                      .joins(:panelist)
                      .where(panelists: { campaign: campaign })
                      .order(:id)

  traffic.find_each do |t|
    print_traffic_record(t, campaign)
  end
end

Offer.find_each do |offer|
  traffic = Onboarding.complete
                      .order(:id)
                      .joins(:panelist)
                      .where(panelists: { offer_code: offer.code })

  traffic.find_each do |t|
    print_traffic_record(t, offer)
  end
end
