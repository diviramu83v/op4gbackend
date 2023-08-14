# frozen_string_literal: true

# This job will return respondent status to cint
class CintPostbackJob < ApplicationJob
  queue_as :default

  def perform(onboarding:)
    CintApi.new.record_cint_response(body: status_body(onboarding))
  end

  private

  def cint_status_code(onboarding)
    return 2 if onboarding.screened?

    return response_code(onboarding) if onboarding.response.present? && onboarding.survey_finished?

    4
  end

  def status_body(onboarding)
    {
      id: onboarding.uid,
      status: cint_status_code(onboarding)
    }
  end

  def response_code(onboarding)
    {
      quotafull: 3,
      terminate: 2,
      complete: 5
    }[onboarding.response.slug&.to_sym]
  end
end
