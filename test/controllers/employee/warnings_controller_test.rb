# frozen_string_literal: true

require 'test_helper'

class Employee::WarningsControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_employee(:admin)
  end

  describe '#index' do
    it 'renders correctly' do
      get warnings_url
      assert_response :ok
    end

    it 'renders correctly for a specific employee' do
      @pm = employees(:operations)
      get employee_warnings_url(@pm)
      assert_response :ok
    end

    describe '#destroy' do
      test 'sets status to inactive' do
        @warning = survey_warnings(:one)
        delete warning_url(@warning), xhr: true

        @warning.reload

        assert_response :ok
        assert @warning.inactive?
      end
    end
  end
end
