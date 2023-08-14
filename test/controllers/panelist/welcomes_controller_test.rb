# frozen_string_literal: true

require 'test_helper'

class Panelist::WelcomesControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  setup do
    load_and_sign_in_confirmed_panelist
    @pixel = tracking_pixels(:standard)
    Panelist.any_instance.stubs(:start_conversions_job).returns(true)
  end

  it "should get the welcome page if panelist hasn't visited it yet" do
    @panelist.update!(welcomed_at: nil)

    get panelist_dashboard_url

    assert_redirected_to welcome_path
  end

  it 'should pass the welcome page if already visited' do
    get panelist_dashboard_url

    assert_ok_with_no_warning
  end

  it 'should load a tracking pixel if one exists' do
    @panelist.update!(welcomed_at: nil)

    get welcome_url

    assert_select 'iframe', height: 1, width: 1 if @pixels.present?
  end

  it "welcome page should populate the panelist's 'welcomed_at' field" do
    @panelist.update!(welcomed_at: nil)
    assert_nil @panelist.welcomed_at

    get welcome_url

    assert @panelist.welcomed_at
  end

  it 'should add an earning record appropriately' do
    @recruiting_campaign = recruiting_campaigns(:standard)
    @recruiting_campaign.update!(incentive: 3.5)
    @panelist.update(welcomed_at: nil, campaign: @recruiting_campaign)

    assert_difference -> { @panelist.earnings.count }, 1 do
      get welcome_url
    end

    @earning = @panelist.earnings.last
    assert_equal @earning.total_amount, 3.5
    assert_equal @earning.panelist_amount, 3.5
    assert_equal @earning.nonprofit_amount, 0
    assert_equal @earning.ledger_description, 'Credit: demographics profile completion'
  end

  it 'should call the MadMimiAddToSignupList job during the #show action' do
    assert_enqueued_with(job: MadMimiAddToSignupListJob) do
      get welcome_url
    end
  end

  it 'should update any related SignupReminders to "ignored"' do
    @signup_reminder = signup_reminder(:standard)
    @signup_reminder.panelist = @panelist
    @signup_reminder.save!

    assert_difference -> { @panelist.signup_reminders.ignored.count }, 1 do
      get welcome_url
    end
  end
end
