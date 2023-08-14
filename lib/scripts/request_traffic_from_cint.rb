# frozen_string_literal: true

# 1 argument: survey_id
# Usage: rails runner lib/scripts/request_traffic_from_cint.rb 25278

survey = Survey.find_by(id: ARGV[0].to_i)

if survey.blank?
  puts 'No survey found'
  return
end

onramp = if survey.onramps.cint.blank?
           Onramp.create(category: Onramp.categories[:cint],
                         survey: survey,
                         check_clean_id: false,
                         check_recaptcha: true,
                         check_gate_survey: false)

         else
           survey.onramps.cint.first
         end
body = {
  name: 'Survey1',
  limit: 100,
  contact: {
    name: 'Bob Barker',
    emailAddress: 'test@test.com',
    company: 'op4g',
    errors: []
  },
  limitType: 0,
  incidenceRate: 80,
  lengthOfInterview: 5,
  linkTemplate: "http://survey.op4g-staging.com/onramps/#{onramp.token}?uid=[ID]",
  testLinkTemplate: "http://survey.op4g-staging.com/onramps/#{onramp.token}?uid=[ID]",
  countryId: 22,
  quotaGroups: [
    {
      name: 'quota group 1',
      quotas: [
        {
          name: 'quota 1',
          limit: 100,
          targetGroup: {
            minAge: 18,
            maxAge: 35,
            gender: 1
          }
        }
      ]
    }
  ]
}
survey_id = CintApi.new.create_survey(body: body)
puts "Survey created id: #{survey_id}"
