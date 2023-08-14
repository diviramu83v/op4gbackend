# frozen_string_literal: true

# a service for creating the quota hash for cint
class CintSurveyData
  def initialize(cint_object)
    @cint_object = cint_object
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def survey_body
    {
      name: @cint_object.name_with_safeguard,
      limit: @cint_object.limit,
      contact: contact_hash,
      limitType: 0,
      incidenceRate: @cint_object.expected_incidence_rate,
      lengthOfInterview: @cint_object.loi,
      linkTemplate: "https://survey.op4g.com/onramps/#{@cint_object.onramp.token}?uid=[ID]",
      testLinkTemplate: "https://survey.op4g.com/onramps/#{@cint_object.onramp.token}?bypass=#{@cint_object.onramp.bypass_token}&uid=[ID]",
      countryId: @cint_object.cint_country_id,
      quotaGroups: [
        {
          name: 'Quota group 1',
          quotas: [
            {
              name: 'quota 1',
              limit: @cint_object.limit,
              targetGroup: {
                variableIds: @cint_object.variable_ids,
                regionIds: @cint_object.region_ids,
                postalCodes: @cint_object.formatted_postal_codes,
                maxAge: @cint_object.max_age,
                minAge: @cint_object.min_age,
                gender: CintSurvey::GENDER_CODES[@cint_object.gender&.to_sym]
              }
            }
          ]

        }
      ]
    }
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  # rubocop:disable Metrics/MethodLength
  def feasibility_body
    {
      incidenceRate: @cint_object.incidence_rate,
      lengthOfInterview: @cint_object.loi,
      countryId: @cint_object.country_id,
      limit: @cint_object.limit,
      fieldPeriod: @cint_object.days_in_field,
      quotaGroups: [
        {
          quotas: [
            {
              limit: @cint_object.limit,
              targetGroup: {
                maxAge: @cint_object.max_age,
                minAge: @cint_object.min_age,
                regionIds: @cint_object.region_ids,
                postalCodes: @cint_object.formatted_postal_codes,
                variableIds: @cint_object.variable_ids,
                gender: CintFeasibility::GENDER_CODES[@cint_object.gender&.to_sym]
              }
            }
          ]
        }
      ]
    }
  end
  # rubocop:enable Metrics/MethodLength

  def webhook_subscription_body
    {
      postbackUrl: 'https://admin.op4g.com/cint_events',
      secret: 'w7jAPCbv3R'
    }
  end

  private

  def contact_hash
    {
      name: @cint_object.survey.project&.manager&.name,
      emailAddress: @cint_object.survey.project&.manager&.email,
      company: 'Op4G',
      errors: []
    }
  end
end
