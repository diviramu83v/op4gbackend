# frozen_string_literal: true

require 'test_helper'

class Employee::ClientSentSurveysControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_admin
    @survey = surveys(:standard)
  end

  describe '#index' do
    it 'should load the page' do
      get survey_client_sent_surveys_url(@survey)

      assert_response :ok
    end
  end

  describe '#new' do
    it 'should load the page' do
      get new_survey_client_sent_survey_url(@survey)

      assert_response :ok
    end
  end

  describe '#edit' do
    setup do
      @client_sent_survey = client_sent_surveys(:standard)
    end

    it 'should load the page' do
      get edit_client_sent_survey_url(@client_sent_survey)

      assert_response :ok
    end
  end

  describe '#create' do
    setup do
      @params = {
        client_sent_survey: {
          employee_id: employees(:operations).id,
          incentive: 25,
          description: 'Test description',
          email_subject: 'Test email subject'
        }
      }
    end
    it 'should create client sent survey' do
      ClientSentSurvey.delete_all
      assert_difference -> { ClientSentSurvey.count } do
        post survey_client_sent_surveys_url(@survey), params: @params
      end

      assert_redirected_to survey_client_sent_surveys_url
    end

    it 'should not create client sent survey' do
      ClientSentSurvey.delete_all
      @params = { client_sent_survey: { employee_id: employees(:operations).id, incentive: 25 } }
      assert_no_difference -> { ClientSentSurvey.count } do
        post survey_client_sent_surveys_url(@survey), params: @params
      end

      assert_template 'new'
    end
  end

  describe '#update' do
    setup do
      @client_sent_survey = client_sent_surveys(:standard)
      @params = { client_sent_survey: { employee_id: employees(:operations).id, description: 'Updated' } }
    end
    it 'should update client sent survey' do
      patch client_sent_survey_url(@client_sent_survey), params: @params

      @client_sent_survey.reload
      assert_equal @client_sent_survey.description, 'Updated'
      assert_redirected_to survey_client_sent_surveys_url(@client_sent_survey.survey)
    end

    it 'should not update client sent survey' do
      @params = { client_sent_survey: { incentive: '' } }
      patch client_sent_survey_url(@client_sent_survey), params: @params

      assert_template 'edit'
    end
  end
end
