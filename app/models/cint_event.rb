# frozen_string_literal: true

# this stores data from cint webhooks events
class CintEvent < ApplicationRecord
  belongs_to :cint_survey, optional: true

  before_save :add_cint_survey
  after_create :change_status_and_send_email_on_repricing_event
  after_create :update_status_on_status_change_event

  private

  def new_status
    events_data.dig('message', 'changes', 'status', 'new')
  end

  def repricing_event?
    events_data['type'] == 'RepricingEvent'
  end

  def status_change_event?
    events_data['type'] == 'SurveyUpdateEvent' && new_status.present?
  end

  def new_cpi_cents
    (events_data['message']['changes']['cpi']['new'] * 100).to_i
  end

  def add_cint_survey
    cint_survey = CintSurvey.find_by(cint_id: events_data.dig('message', 'surveyId'))
    self.cint_survey = cint_survey
  end

  def cint_survey_status_class(status)
    styles = {
      1 => 'live',
      2 => 'paused',
      3 => 'complete',
      4 => 'closed',
      5 => 'halted'
    }

    styles[status]
  end

  def change_status_and_send_email_on_repricing_event
    return unless repricing_event? && cint_survey.present?

    cint_survey.halted!
    EmployeeMailer.notify_of_repricing_event(cint_survey.survey.project.manager, cint_survey, self).deliver_later

    cint_survey.update!(cpi_cents: new_cpi_cents)
  end

  def update_status_on_status_change_event
    return unless status_change_event? && cint_survey.present?

    cint_survey.update(status: cint_survey_status_class(new_status))
  end
end
