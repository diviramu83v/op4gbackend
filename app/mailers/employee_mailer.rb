# frozen_string_literal: true

# Send emails to employees.
class EmployeeMailer < ApplicationMailer
  default from: 'it@op4g.com'

  def survey_milestone_reached(manager, milestone)
    @manager = manager
    @milestone = milestone

    @label = "#{@milestone.project.extended_name} / #{@milestone.survey.name}"

    mail(
      to: @manager.email,
      subject: "MILESTONE REACHED: #{@milestone.target_completes} completes for #{@label}"
    )
  end

  def requested_completes_reached(onramp, requested_completes)
    @onramp = onramp
    @manager = onramp.project.manager
    @vendor = onramp.vendor_batch.vendor
    @requested_completes = requested_completes

    @label = "#{onramp.project.extended_name} / #{onramp.survey.name}"

    mail(
      to: @manager.email,
      subject: "REQUESTED COMPLETES REACHED: #{@vendor.name} - #{@label}"
    )
  end

  # Temporarily sending an email for this, just to keep tabs on how often it's happening.
  def onramp_security_turned_off(onramp)
    @onramp = onramp
    @project = onramp.project

    mail(
      to: 'archiei@op4g.com',
      subject: "security turned off: project #{@project.id}"
    )
  end

  def notify_of_repricing_event(manager, cint_survey, cint_event)
    @manager = manager
    @survey = cint_survey.survey
    @cint_event = cint_event

    mail(
      to: @manager.email,
      subject: "Repricing event has occured on cint quota for survey #{@survey.id}"
    )
  end
end
