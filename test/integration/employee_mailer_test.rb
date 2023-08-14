# frozen_string_literal: true

require 'test_helper'

class EmployeeMailerTest < ActionDispatch::IntegrationTest
  setup do
    @manager = employees(:operations)
    sign_in(@manager)

    @milestone = complete_milestones(:standard)
    @label = "#{@milestone.project.extended_name} / #{@milestone.survey.name}"

    @onramp = onramps(:panel)
  end

  describe 'suvey milestone reached email' do
    it 'should contain the correct header and body information' do
      mail = EmployeeMailer.survey_milestone_reached(@manager, @milestone).deliver_now

      assert_equal mail.to, [@manager.email]
      assert_equal mail.from, ['it@op4g.com']
      assert_equal mail.subject, "MILESTONE REACHED: #{@milestone.target_completes} completes for #{@label}"
      assert_match "/surveys/#{@milestone.survey_id}", mail.body.encoded
      assert_match @milestone.survey.status, mail.body.encoded
    end
  end

  describe 'onramp security turned off email' do
    it 'should be sent to Ryan and Archie' do
      mail = EmployeeMailer.onramp_security_turned_off(@onramp).deliver_now

      assert_equal mail.to, ['archiei@op4g.com']
    end
  end

  describe 'notify of repricing event' do
    setup do
      stub_request(:patch, 'https://fuse.cint.com/ordering/surveys/227').to_return(status: 200)
      events_data = { type: 'RepricingEvent',
                      message:
                      { source: 1,
                        changes: { cpi: { new: 42.8, old: 19 }, incidenceRate: { new: 32, old: 80 } },
                        surveyId: 227 },
                      messageId: 636_362_266_611_724_400,
                      published: '2017-06-01T15:05:21.4461828Z' }
      @cint_survey = cint_surveys(:standard)
      @cint_event = @cint_survey.cint_events.create(events_data: events_data)
    end

    it 'should send to the project manager' do
      mail = EmployeeMailer.notify_of_repricing_event(@manager, @cint_survey, @cint_event).deliver_now

      assert_equal mail.to, [@manager.email]
      assert_equal mail.from, ['it@op4g.com']
    end
  end
end
