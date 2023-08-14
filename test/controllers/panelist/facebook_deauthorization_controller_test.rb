# frozen_string_literal: true

require 'test_helper'

class Panelist::FacebookDeauthorizationControllerTest < ActionDispatch::IntegrationTest
  describe 'create' do
    it 'removes the facebook parameters from the panelist\'s account' do
      now = Time.now.utc

      load_and_sign_in_confirmed_panelist

      @panelist.update!(
        email: 'test@test.com',
        facebook_authorized: now,
        facebook_image: 'original-base64-image',
        first_name: 'first-name',
        last_name: 'last-name',
        provider: 'original-facebook',
        facebook_uid: 'uid123'
      )

      post facebook_deauthorization_url

      @panelist.reload

      assert_nil @panelist.facebook_authorized
      assert_nil @panelist.facebook_image
      assert_nil @panelist.provider
      assert_nil @panelist.facebook_uid

      assert_redirected_to edit_account_email_url
    end

    it 'throws an error and shows an alert if the facebook data cannot be removed' do
      now = Time.now.utc

      load_and_sign_in_confirmed_panelist

      @panelist.update!(
        email: 'test@test.com',
        facebook_authorized: now,
        facebook_image: 'original-base64-image',
        first_name: 'first-name',
        last_name: 'last-name',
        provider: 'original-facebook',
        facebook_uid: 'uid123'
      )

      Panelist.any_instance.stubs(:update).returns(false)
      post facebook_deauthorization_url

      assert_not_nil flash[:alert]
      assert_redirected_to edit_account_email_url
    end
  end
end
