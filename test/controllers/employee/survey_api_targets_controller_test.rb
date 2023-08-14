# frozen_string_literal: true

require 'test_helper'

class Employee::SurveyApiTargetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in employees(:operations)
  end

  describe '#new' do
    setup do
      @survey = surveys(:standard)
    end

    it 'should load the survey api target page' do
      get new_survey_api_target_url(@survey)

      assert_response :ok
    end
  end

  describe '#create' do
    setup do
      @survey = surveys(:standard)
    end

    it 'should create a survey api target' do
      params = {
        survey_api_target: {
          countries: ['US'],
          genders: ['female'],
          payout: 15,
          education: ['professional'],
          employment: %w[full_time unemployed],
          income: ['under_twenty_five_thousand'],
          race: ['asian_indian'],
          number_of_employees: %w[none one_hundred_to_under_two_hundred_fifty],
          min_age: 16,
          max_age: 22,
          decision_maker: %w[corporate_travel_self it_infrastructure_systems_integration],
          custom_question: 'anything'
        }
      }

      post survey_api_target_url(@survey), params: params

      assert @survey.survey_api_target.present?
      assert_redirected_to survey_api_target_url(@survey)
    end

    it 'should not create a survey api target' do
      params = {
        survey_api_target: {
          countries: []
        }
      }

      post survey_api_target_url(@survey), params: params

      assert @survey.survey_api_target.blank?
      assert_response :ok
    end
  end

  describe '#show' do
    setup do
      @survey = surveys(:standard)
    end

    it 'should load the survey page' do
      get survey_api_target_url(@survey)

      assert_response :ok
    end
  end

  describe '#edit' do
    setup do
      @target = survey_api_targets(:standard)
      @survey = @target.survey
    end

    it 'should load the survey api target page' do
      get edit_survey_api_target_url(@survey)

      assert_response :ok
    end
  end

  describe '#update' do
    setup do
      @target = survey_api_targets(:standard)
      @survey = @target.survey
    end

    it 'should update a survey api target' do
      params = {
        survey_api_target: {
          countries: ['US'],
          genders: ['female'],
          payout: 15,
          education: ['professional'],
          employment: %w[full_time unemployed],
          income: ['under_twenty_five_thousand'],
          race: ['asian_indian'],
          number_of_employees: %w[none one_hundred_to_under_two_hundred_fifty],
          min_age: 16,
          max_age: 22,
          decision_maker: %w[corporate_travel_self it_infrastructure_systems_integration],
          custom_question: 'anything'
        }
      }

      patch survey_api_target_url(@survey), params: params

      assert @survey.survey_api_target.present?
      assert_redirected_to survey_api_target_url(@survey)
    end

    it 'should not update a survey api target' do
      params = {
        survey_api_target: {
          countries: []
        }
      }

      patch survey_api_target_url(@survey), params: params

      assert @survey.survey_api_target.present?
      assert_response :ok
    end
  end
end
