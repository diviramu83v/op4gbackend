# frozen_string_literal: true

require 'test_helper'

class Employee::CintEventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cint_survey = cint_surveys(:standard)
    @params = [{
      messageId: 636_362_266_611_724_400,
      type: 'SurveyUpdateEvent',
      published: '2017-07-21T09:37:41.094537Z',
      message: {
        changes: {
          status: {
            old: 0,
            new: 1
          }
        },
        surveyId: 227,
        source: 1
      }
    }].to_json
  end

  describe '#create' do
    it 'successfully creates the event' do
      assert_difference -> { CintEvent.count }, 1 do
        post cint_events_url(@cint_survey), params: @params, headers: { 'X-Cint-Webhook-Secret' => Base64.encode64('w7jAPCbv3R') }
      end

      assert_response :ok
    end
  end

  it 'does not create the event with a bad secret key' do
    assert_no_difference -> { CintEvent.count } do
      post cint_events_url(@cint_survey), params: @params, headers: { 'X-Cint-Webhook-Secret' => 'bad-secret-key' }
    end
  end

  it 'does not create the event' do
    CintEvent.any_instance.expects(:save).returns(false)
    assert_no_difference -> { CintEvent.count } do
      post cint_events_url(@cint_survey), params: @params, headers: { 'X-Cint-Webhook-Secret' => Base64.encode64('w7jAPCbv3R') }
    end

    assert_response :unprocessable_entity
  end

  it 'creates event and halts the survey on a repricing event' do
    @params = [{
      messageId: 636_362_266_611_724_400,
      type: 'RepricingEvent',
      published: '2017-07-21T09:37:41.094537Z',
      message: {
        changes: {
          cpi: {
            old: 2.4,
            new: 6.0
          }
        },
        surveyId: 227,
        source: 1
      }
    }].to_json

    assert_difference -> { CintEvent.count }, 1 do
      stub_request(:patch, 'https://fuse.cint.com/ordering/surveys/227').to_return(status: 200)
      post cint_events_url(@cint_survey), params: @params, headers: { 'X-Cint-Webhook-Secret' => Base64.encode64('w7jAPCbv3R') }
    end
    @cint_survey.reload

    assert @cint_survey.halted?
  end
end
