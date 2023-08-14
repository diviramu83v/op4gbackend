# frozen_string_literal: true

require 'test_helper'

class SuspendOutOfCountryPanelistsJobTest < ActiveJob::TestCase
  describe 'out-of-country traffic data' do
    setup do
      @traffic_check = traffic_checks(:pre_new)
      @panelist = panelists(:standard)
      @onboarding = onboardings(:standard)
      @onboarding.update!(panelist: @panelist)
      @traffic_check.update!(data_collected: @data)

      stub_request(:get, 'https://gateway.navigatorsurveys.com/cleanid/result/eb815afc-c4eb-47e9-89a8-8981b32f7ca4')
        .to_return(status: 200,
                   body: '{"result": { "IpData": { "IpCountryCode": "UK" }}}',
                   headers: { 'Content-Type' => 'application/json' })
    end

    test 'suspend panelist based on traffic clean_id country' do
      assert_changes '@panelist.reload.status', from: 'active', to: 'suspended' do
        SuspendOutOfCountryPanelistsJob.perform_now
      end
    end
  end
end
