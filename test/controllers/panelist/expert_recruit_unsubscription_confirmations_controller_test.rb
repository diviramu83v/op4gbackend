# frozen_string_literal: true

require 'test_helper'

class Panelist::ExpertRecruitUnsubscriptionConfirmationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @expert_recruit = expert_recruits(:standard)
  end

  describe '#show' do
    it 'should load the page' do
      get expert_unsubscribe_confirmation_url, params: { email: @expert_recruit.email, unsubscribe_token: @expert_recruit.unsubscribe_token }

      assert_response :ok
    end
  end
end
