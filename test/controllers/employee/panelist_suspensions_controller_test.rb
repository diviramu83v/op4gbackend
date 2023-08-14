# frozen_string_literal: true

require 'test_helper'

class Employee::PanelistSuspensionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_employee = employees(:admin)
    sign_in @admin_employee
  end

  describe '#new' do
    it 'should load the new page' do
      get new_panelist_suspension_url

      assert_response :ok
    end
  end

  describe '#create' do
    it 'should suspend a list of panelists when email passed in' do
      stub_request(:post, /madmimi.com/).to_return(status: 200, body: '', headers: {})
      params = {
        panelist_emails_or_tokens: {
          emails_or_tokens: Panelist.first.email
        }
      }

      assert_difference -> { Panelist.suspended.count } do
        post panelist_suspensions_url, params: params
      end
    end

    it 'should suspend a list of panelists when token passed in' do
      stub_request(:post, /madmimi.com/).to_return(status: 200, body: '', headers: {})
      onboarding = Onboarding.first
      params = {
        panelist_emails_or_tokens: {
          emails_or_tokens: onboarding.token
        }
      }

      assert_difference -> { Panelist.suspended.count } do
        post panelist_suspensions_url, params: params
      end
    end

    it 'should not suspend if no panelists are found' do
      stub_request(:post, /madmimi.com/).to_return(status: 200, body: '', headers: {})
      params = {
        panelist_emails_or_tokens: {
          emails_or_tokens: 'invalid'
        }
      }

      assert_no_difference -> { Panelist.suspended.count } do
        post panelist_suspensions_url, params: params
      end
    end
  end
end
