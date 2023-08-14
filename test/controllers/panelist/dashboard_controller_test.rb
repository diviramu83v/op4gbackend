# frozen_string_literal: true

require 'test_helper'

class Panelist::DashboardControllerTest < ActionDispatch::IntegrationTest
  describe 'DashboardController' do
    setup do
      load_and_sign_in_confirmed_panelist_with_base_info
    end

    describe 'show with panelist_dashboard_cards activated' do
      it 'should get the panelist dashboard with paid completes' do
        setup_paid_completions
        get panelist_dashboard_url
        assert_response :success
      end

      it 'should get the panelist dashboard with rejected completes' do
        setup_rejected_completions
        get panelist_dashboard_url
        assert_response :success
      end

      it 'should get the panelist dashboard with finished completes' do
        setup_finished_completions
        get panelist_dashboard_url
        assert_response :success
      end

      it 'should go to the terms and conditions page if terms and conditions are not accepted yet' do
        @panelist.update!(agreed_to_terms_at: nil)
        get panelist_dashboard_url
        assert_redirected_to accept_terms_and_conditions_url
      end

      # it 'should go to an activity when the `TAKE` button is pressed' do
      # end

      # it 'should remove an activity when the `DISMISS` button is pressed' do
      # end
    end

    describe 'terms' do
      it 'should get the `Terms and Conditions` page' do
        get terms_and_conditions_url
        assert_response :success
      end
    end

    describe 'privacy policy' do
      it 'should get the `Privacy Policy` page' do
        get privacy_policy_url
        assert_response :success
      end
    end

    describe 'sign out' do
      it 'should sign out when the `Sign Out` button is pressed' do
        delete destroy_panelist_session_url
        assert_redirected_to new_panelist_session_url
      end
    end
  end

  def setup_paid_completions
    ProjectInvitation.create(panelist: @panelist, status: 'paid')
    ProjectInvitation.stubs(:complete).returns(ProjectInvitation.where(panelist: @panelist))
  end

  def setup_rejected_completions
    ProjectInvitation.create(panelist: @panelist, status: 'rejected')
    ProjectInvitation.stubs(:complete).returns(ProjectInvitation.where(panelist: @panelist))
  end

  def setup_finished_completions
    ProjectInvitation.create(panelist: @panelist, status: 'finished')
    ProjectInvitation.stubs(:complete).returns(ProjectInvitation.where(panelist: @panelist))
  end
end
