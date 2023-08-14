# frozen_string_literal: true

# Returns the api body for disqo api calls
class DisqoApiPayload
  def initialize(disqo_object:)
    @disqo_object = disqo_object
  end

  # rubocop:disable Metrics/MethodLength
  def project_body
    {
      id: @disqo_object.disqo_project_quota_id,
      supplierId: 54_637,
      studyType: 'AD_HOC',
      url: "https://survey.op4g.com/onramps/#{@disqo_object.disqo_onramp.token}",
      loi: @disqo_object.loi,
      name: @disqo_object.survey.project.id,
      conversionRate: @disqo_object.conversion_rate,
      cpi: @disqo_object.cpi,
      completesWanted: @disqo_object.completes_wanted,
      qualifications: @disqo_object.qualifications,
      trackingField: 'COMPLETES',
      enforceScreenOut: true,
      devices: %w[
        DESKTOP
        PHONE
        TABLET
      ],
      country: @disqo_object.find_in_qualifications('geocountry').first
    }
  end
  # rubocop:enable Metrics/MethodLength

  def project_quota_body
    {
      id: @disqo_object.quota_id,
      cpi: @disqo_object.cpi,
      completesWanted: @disqo_object.completes_wanted,
      qualifications: @disqo_object.qualifications
    }
  end

  # rubocop:disable Metrics/MethodLength
  def feasibility_project_body
    {
      project: {
        country: @disqo_object.find_in_qualifications('geocountry').first,
        daysInField: @disqo_object.days_in_field,
        incidenceRate: @disqo_object.incidence_rate,
        loi: @disqo_object.loi,
        devices: %w[
          DESKTOP
          PHONE
          TABLET
        ],
        quotas: [
          {
            id: 'feasibility',
            cpi: @disqo_object.cpi,
            completesWanted: @disqo_object.completes_wanted,
            qualifications: @disqo_object.qualifications
          }
        ]
      }
    }
  end
  # rubocop:enable Metrics/MethodLength
end
