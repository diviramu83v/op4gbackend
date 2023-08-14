# frozen_string_literal: true

require 'test_helper'

class Panelist::EmailsControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_confirmed_panelist
  end

  describe '#edit' do
    test 'success' do
      @panelist.update!(sign_in_count: 1)

      get edit_account_email_url

      assert_response :success
      assert_template :edit
    end
  end

  describe '#update' do
    setup do
      @params = { panelist: { email: 'iam@robot.com' } }
    end

    test 'success' do
      assert_not_equal 'iam@robot.com', @panelist.email

      patch account_email_url, params: @params
      @panelist.reload

      assert_equal 'Account successfully updated.', flash[:notice]
      assert_equal 'iam@robot.com', @panelist.email
    end

    test 'failure: .update failure' do
      Panelist.any_instance.expects(:update).returns(false)

      assert_no_changes('@panelist.reload.email') do
        patch account_email_url, params: @params
      end

      assert_template :edit
      assert_equal 'Account could not be updated.', flash.now[:alert]
    end

    test 'failure: record not unique' do
      Panelist.any_instance.expects(:update).raises(ActiveRecord::RecordNotUnique)

      assert_no_changes('@panelist.reload.email') do
        patch account_email_url, params: @params
      end

      assert_template :edit
      assert_equal 'Account could not be updated.', flash.now[:alert]
    end
  end
end
