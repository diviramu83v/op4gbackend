# frozen_string_literal: true

# Usage: rails runner lib/scripts/sync_cint_cpi.rb

auth = { 'X-Api-Key' => Settings.cint_api_key, 'Content-Type' => 'application/*+json', 'Accept' => 'text/json' }

CintSurvey.all.find_each do |cint_survey|
  next unless cint_survey.editable?
  next if cint_survey.cint_id.blank?

  url = "#{Settings.cint_api_url}/ordering/Surveys/#{cint_survey.cint_id}"
  response = HTTParty.get(url, headers: auth)
  cpi_response = response['cpi']

  next if cpi_response.blank?

  cpi = cpi_response['amount']

  next if cpi.blank?

  if (cpi * 100) != cint_survey.cpi_cents
    puts "Changing #{cint_survey.cint_id} from #{cint_survey.cpi.to_f} to #{cpi}"
    cint_survey.update(cpi_cents: (cpi * 100).to_i)
  end
end
