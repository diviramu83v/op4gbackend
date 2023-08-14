# frozen_string_literal: true

require 'test_helper'

class Panelist::ContributionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_confirmed_panelist
    @panelist.update!(nonprofit: nonprofits(:one))
  end

  it 'should get panelist contributions page' do
    get account_contribution_url

    assert_response :success
  end

  it 'should update panelist contribution' do
    put account_contribution_url, params: { contribution_percent: { contribution: 25 } }
    @panelist.reload
    assert_equal @panelist.donation_percentage, 25
    assert_redirected_to account_contribution_url

    put account_contribution_url, params: { contribution_percent: { contribution: 50 } }
    @panelist.reload
    assert_equal @panelist.donation_percentage, 50
    assert_redirected_to account_contribution_url

    put account_contribution_url, params: { contribution_percent: { contribution: 75 } }
    @panelist.reload
    assert_equal @panelist.donation_percentage, 75
    assert_redirected_to account_contribution_url

    put account_contribution_url, params: { contribution_percent: { contribution: 100 } }
    @panelist.reload
    assert_equal @panelist.donation_percentage, 100
    assert_redirected_to account_contribution_url
  end

  it 'should not update locked panelist contribution' do
    @panelist.update!(lock_flag: true)

    put account_contribution_url, params: { contribution_percent: { contribution: 25 } }
    assert_not_equal @panelist.donation_percentage, 25
    assert_redirected_to panelist_dashboard_url
  end
end
