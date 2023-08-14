# frozen_string_literal: true

require 'test_helper'

class Panelist::OmniauthCallbacksControllerTest < ActionDispatch::IntegrationTest
  describe 'facebook callback' do
    it 'logs the panelist in if the panelist has used "continue with facebook" before' do
      FeatureManager.stubs(:panelist_facebook_auth?).returns(true)

      OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(
        provider: 'facebook',
        uid: '123test',
        info: {
          email: 'test@test.com',
          image: 'base64-image',
          name: 'The Dude'
        }
      )

      now = Time.now.utc
      @panelist = panelists(:standard)
      @panelist.update!(
        email: 'test@test.com',
        facebook_authorized: now,
        facebook_image: 'original-base64-image',
        first_name: 'first-name',
        last_name: 'last-name',
        provider: 'original-facebook',
        facebook_uid: 'uid123'
      )

      confirm_panelist!(@panelist)

      post panelist_facebook_omniauth_callback_url
      @panelist.reload

      assert_redirected_to panelist_dashboard_url
      assert @panelist.facebook_authorized == now.to_s
      assert @panelist.facebook_image == 'base64-image'
      assert @panelist.provider == 'original-facebook'
      assert @panelist.facebook_uid == 'uid123'
    end

    it 'logs the panelist in and adds facebook data if the panelist hasn\'t used "continue with facebook" before' do
      FeatureManager.stubs(:panelist_facebook_auth?).returns(true)

      OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(
        provider: 'facebook',
        uid: '123test',
        info: {
          email: 'test@test.com',
          image: 'base64-image',
          name: 'The Dude'
        }
      )

      post panelist_facebook_omniauth_callback_url

      assert_redirected_to panelist_dashboard_url

      @panelist = Panelist.find_by(facebook_uid: '123test')

      assert @panelist.confirmed_at.present?
      assert @panelist.facebook_image == 'base64-image'
      assert @panelist.provider == 'facebook'
      assert @panelist.facebook_uid == '123test'
    end

    it 'returns an error if the proper keys are not found in the request object' do
      FeatureManager.stubs(:panelist_facebook_auth?).returns(true)

      OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(wrong_key: '')

      post panelist_facebook_omniauth_callback_url

      assert_redirected_to new_panelist_session_url
    end

    it 'will redirect to the panelist login page unless the feature flag is turned on' do
      FeatureManager.stubs(:panelist_facebook_auth?).returns(false)

      OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(
        provider: 'facebook',
        uid: '123test',
        info: {
          email: 'test@test.com',
          image: 'base64-image',
          name: 'The Dude'
        }
      )

      @panelist = panelists(:standard)
      @panelist.update!(email: 'test@test.com')
      confirm_panelist!(@panelist)

      post panelist_facebook_omniauth_callback_url

      assert_redirected_to new_panelist_session_url
    end

    it 'redirects back to the panelist login if a failure occurs because the panelist declines to provide info' do
      OmniAuth.config.mock_auth[:facebook] = :user_denied

      now = Time.now.utc
      @panelist = panelists(:standard)
      @panelist.update!(
        email: 'test@test.com',
        facebook_authorized: now,
        facebook_image: 'original-base64-image',
        first_name: 'first-name',
        last_name: 'last-name',
        provider: 'original-facebook',
        facebook_uid: 'uid123'
      )

      confirm_panelist!(@panelist)

      declined_request =
        panelist_facebook_omniauth_callback_url +
        '?error=access_denied' \
        '&error_code=200' \
        '&error_description=Permissions+error' \
        '&error_reason=user_denied' \
        '&state=1d52946f07863157545b07f02fa147381a0bf89c1a157115'

      get declined_request

      @panelist.reload

      assert_redirected_to new_panelist_session_url
    end

    it 'redirects back to the panelist login if the user isn\t valid' do
      OmniAuth.config.mock_auth[:facebook] = :user_denied

      now = Time.now.utc
      @panelist = panelists(:standard)
      @panelist.update!(
        email: 'test@test.com',
        facebook_authorized: now,
        facebook_image: 'original-base64-image',
        first_name: 'first-name',
        last_name: 'last-name',
        provider: 'original-facebook',
        facebook_uid: 'uid123'
      )

      confirm_panelist!(@panelist)

      declined_request =
        panelist_facebook_omniauth_callback_url +
        '?error=access_denied' \
        '&error_code=200' \
        '&error_description=Permissions+error' \
        '&error_reason=user_denied' \
        '&state=1d52946f07863157545b07f02fa147381a0bf89c1a157115'

      get declined_request

      @panelist.reload

      assert_redirected_to new_panelist_session_url
    end
  end

  describe 'paypal callback' do
    setup do
      OmniAuth.config.mock_auth[:paypal_oauth2] = OmniAuth::AuthHash.new(
        provider: 'paypal',
        uid: '123test',
        info: {
          email: 'pp-test@test.com',
          image: 'base64-image',
          name: 'The Dude'
        },
        extra: {
          verified_account: true
        }
      )

      OmniAuth.config.before_callback_phase do |env|
        env['omniauth.params'] = { 'panelist_email' => @panelist.email }
      end

      @panelist = panelists(:standard)
      @panelist.update(email: 'test@test.com')
    end

    it 'updates the panelist\'s Paypal account status to verified and gives a notice' do
      FeatureManager.stubs(:panelist_paypal_verification?).returns(true)

      post panelist_paypal_oauth2_omniauth_callback_url

      @panelist.reload

      assert_equal @panelist.paypal_verification_status == 'verified', true
      assert_not_nil flash[:notice]
      assert_redirected_to panelist_dashboard_url
    end

    it 'does not allow the call if the feature flag is off' do
      FeatureManager.stubs(:panelist_paypal_verification?).returns(false)

      post panelist_paypal_oauth2_omniauth_callback_url

      assert_redirected_to new_panelist_session_url
    end

    it 'gives a warning and does not verify if Paypal reports the account as not verified' do
      FeatureManager.stubs(:panelist_paypal_verification?).returns(true)

      load_and_sign_in_confirmed_panelist_with_base_info

      @panelist.update(paypal_verification_status: 'unverified')

      OmniAuth.config.mock_auth[:paypal_oauth2] = OmniAuth::AuthHash.new(
        provider: 'paypal',
        uid: '123test',
        info: {
          email: @panelist.email,
          image: 'base64-image',
          name: 'The Dude'
        },
        extra: {
          verified_account: 'false'
        }
      )

      post panelist_paypal_oauth2_omniauth_callback_url

      @panelist.reload

      assert_equal @panelist.paypal_verification_status == 'unverified', true
      assert_not_nil flash[:notice]
      assert_redirected_to panelist_dashboard_url
    end

    it 'gives an error alert if the panelist record is not found' do
      FeatureManager.stubs(:panelist_paypal_verification?).returns(true)

      OmniAuth.config.mock_auth[:paypal_oauth2] = OmniAuth::AuthHash.new(
        provider: 'paypal',
        uid: '123test',
        info: {
          email: 'test@test.com',
          image: 'base64-image',
          name: 'The Dude'
        },
        extra: {
          verified_account: 'true'
        }
      )

      # overwrite the setup env param so the email doesn't match
      OmniAuth.config.before_callback_phase do |env|
        env['omniauth.params'] = { 'panelist_email' => 'wrong-email@test.com' }
      end

      load_and_sign_in_confirmed_panelist_with_base_info

      post panelist_paypal_oauth2_omniauth_callback_url

      assert_not_nil flash[:alert]
      assert_redirected_to panelist_dashboard_url
    end

    it 'gives an error alert if there is a problem communicating with Paypal' do
      FeatureManager.stubs(:panelist_paypal_verification?).returns(true)

      OmniAuth.config.mock_auth[:paypal_oauth2] = OmniAuth::AuthHash.new(
        provider: 'paypal',
        uid: '123test',
        info: {
          email: 'test@test.com',
          image: 'base64-image',
          name: 'The Dude'
        },
        extra: {}
      )

      load_and_sign_in_confirmed_panelist_with_base_info

      post panelist_paypal_oauth2_omniauth_callback_url

      assert_not_nil flash[:alert]
      assert_redirected_to panelist_dashboard_url
    end

    it 'returns an error if the proper keys are not found in the request object' do
      FeatureManager.stubs(:panelist_paypal_verification?).returns(true)

      OmniAuth.config.mock_auth[:paypal_oauth2] = OmniAuth::AuthHash.new(
        provider: 'paypal',
        uid: '123test',
        info: {
          email: 'test@test.com',
          image: 'base64-image',
          name: 'The Dude'
        },
        extra: {}
      )

      load_and_sign_in_confirmed_panelist_with_base_info

      post panelist_paypal_oauth2_omniauth_callback_url

      assert_redirected_to panelist_dashboard_url
    end
  end
end
