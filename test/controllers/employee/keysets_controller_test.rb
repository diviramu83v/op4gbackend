# frozen_string_literal: true

require 'test_helper'

class Employee::KeysetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_operations_employee
  end

  describe '#destroy' do
    test 'calls a job and redirects' do
      @survey = surveys(:standard)
      DestroyKeysJob.expects(:perform_later)

      delete survey_keysets_url(@survey)

      assert_redirected_to survey_keys_url(@survey)
    end

    it 'raises an error if the survey is not found' do
      assert_raises ActiveRecord::RecordNotFound do
        delete survey_keysets_url(Survey.find(0))
      end
    end
  end
end
