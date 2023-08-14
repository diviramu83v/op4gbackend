# frozen_string_literal: true

require 'test_helper'

class Employee::RecontactTrafficDetailsControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_operations_employee
    @recontact = surveys(:standard)
    @mock_file = Minitest::Mock.new
    @mock_file.expect(:read, 'something')
  end

  describe '#show' do
    it 'should render ok' do
      get recontact_traffic_details_url(@recontact)

      assert(onboardings)
      assert_response :ok
    end

    it 'should return the all traffic csv if report is found' do
      URI.stub(:open, @mock_file) do
        TrafficReport.any_instance.stubs(:report).returns('irrelevant')

        get recontact_traffic_details_url(@recontact, format: :csv)

        assert_response :ok
      end
    end

    # rubocop:disable Rails/SkipsModelValidations
    it 'should redirect to traffic details if no report is found' do
      TrafficReport.all.update_all(report_type: nil)

      URI.stub(:open, @mock_file) do
        get recontact_traffic_details_url(@recontact, format: :csv)

        assert_redirected_to recontact_traffic_details_url(@recontact)
      end
    end
    # rubocop:enable Rails/SkipsModelValidations
  end
end
