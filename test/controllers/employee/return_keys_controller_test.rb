# frozen_string_literal: true

require 'test_helper'

class Employee::ReturnKeysControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  setup do
    load_and_sign_in_admin
    @survey = surveys(:standard)
  end

  describe '#index' do
    it 'should load the page' do
      get survey_return_keys_url(@survey)

      assert_response :ok
    end

    it 'should download the keys' do
      get survey_return_keys_url(@survey, format: :csv)

      assert_response :ok
    end
  end

  describe '#new' do
    it 'should load the page' do
      get new_survey_return_key_url(@survey)

      assert_response :ok
    end
  end

  describe '#create' do
    it 'should generate the specified amount of return keys' do
      assert_enqueued_jobs 1 do
        post survey_return_keys_url(@survey), params: { return_keys: { number: '10' } }
      end
    end
  end
end
