# frozen_string_literal: true

require 'test_helper'

class Employee::SurveyCompletionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_operations_employee
  end

  describe '#show' do
    setup do
      @survey = surveys(:standard)
      @mock_file = Minitest::Mock.new
      @mock_file.expect(:read, 'something')
    end

    it 'should return the survey completions csv if a report is found' do
      URI.stub(:open, @mock_file) do
        TrafficReport.any_instance.stubs(:report).returns('irrelevant')

        get survey_completions_url(@survey, format: :csv)

        assert_response :ok
      end
    end

    # rubocop:disable Rails/SkipsModelValidations
    it 'should redirect to the traffic_details_url if no report is found' do
      TrafficReport.all.update_all(report_type: nil)

      URI.stub(:open, @mock_file) do
        get survey_completions_url(@survey, format: :csv)

        assert_redirected_to survey_traffic_details_url(@survey)
      end
    end
    # rubocop:enable Rails/SkipsModelValidations
  end
end
