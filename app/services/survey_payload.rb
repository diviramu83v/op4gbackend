# frozen_string_literal: true

# Constructs API payload data for one survey.
class SurveyPayload
  include ActionView::Helpers::NumberHelper

  def self.build(survey, token)
    new(survey, token).build
  end

  def initialize(survey, token)
    @survey = survey
    @token = token
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def build
    onramp = @survey.onramps.api.for_api_vendor(@token.vendor).first
    return nil if onramp.nil?

    onramp_url = "https://survey.op4g.com/onramps/#{onramp.token}?uid={{uid}}"
    target = @survey.survey_api_target
    return nil if target.nil?

    target_payload = build_target_payload(target)

    {
      uuid: onramp.token,
      project_id: onramp.project.id,
      url: CGI.unescape(onramp_url),
      loi_minutes: @survey.loi,
      payout_dollars: number_to_currency(target.payout).delete('$'),
      target: target_payload,
      remaining_completes: @survey.remaining_completes,
      survey_incidence_rate: @survey.incidence_rate,
      vendor_incidence_rate: onramp.incidence_rate
    }
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  private

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
  def build_target_payload(target)
    states = State.where(code: target.states)

    {
      country: target.countries,
      states: target.states || [],
      zip_codes: ZipCode.where(state: states).map(&:code).to_a,
      education: target.education || [],
      employment: target.employment || [],
      income: target.income || [],
      race: target.race || [],
      number_of_employees: target.number_of_employees || [],
      job_title: target.job_title || [],
      decision_maker: target.decision_maker || [],
      custom_option: target.custom_option || [],
      age: target_age_or_default(target),
      gender: target_gender_or_default(target)
    }
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity

  def target_age_or_default(target)
    target.age_range.presence || (SurveyApiTarget::MIN_AGE..SurveyApiTarget::MAX_AGE).to_a
  end

  def target_gender_or_default(target)
    target.genders.presence || SurveyApiTarget::GENDERS
  end
end
