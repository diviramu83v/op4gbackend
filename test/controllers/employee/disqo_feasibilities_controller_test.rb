# frozen_string_literal: true

require 'test_helper'

# this is the controller test for the disqo feasibilities controller
class Employee::DisqoFeasibilitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @employee = employees(:recruitment)
    sign_in(@employee)
  end

  describe '#index' do
    test 'load the page' do
      get disqo_feasibilities_url

      assert_response :ok
    end
  end

  describe '#new' do
    test 'load the page' do
      get new_disqo_feasibility_url

      assert_response :ok
    end
  end

  describe '#create' do
    setup do
      @params = {
        disqo_feasibility: {
          cpi: 2,
          loi: 10,
          completes_wanted: 1000,
          days_in_field: 60,
          incidence_rate: 50,
          qualifications: {
            geocountry: 'US'
          }
        }
      }
    end

    # rubocop:disable Style/OpenStructUse
    test 'create a feasibility' do
      DisqoApi.any_instance.expects(:create_quota_feasibility).returns(
        OpenStruct.new(code: 200, 'project' => { 'quotas' => [{ 'id' => 'feasibility', 'numberOfPanelists' => 17_890 }] })
      )

      assert_difference -> { DisqoFeasibility.count }, 1 do
        post disqo_feasibilities_url, params: @params
      end

      assert_redirected_to disqo_feasibilities_url
    end
    # rubocop:enable Style/OpenStructUse
  end
end
