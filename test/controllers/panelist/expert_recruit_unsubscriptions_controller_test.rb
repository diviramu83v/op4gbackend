# frozen_string_literal: true

require 'test_helper'

class Panelist::ExpertRecruitUnsubscriptionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @expert_recruit = expert_recruits(:standard)
  end

  describe '#show' do
    it 'should load the page' do
      get expert_unsubscribe_url, params: { email: @expert_recruit.email, unsubscribe_token: @expert_recruit.unsubscribe_token }

      assert_response :ok
    end
  end

  describe '#create' do
    it 'should create an unsubscription' do
      assert_difference -> { ExpertRecruitUnsubscription.count } do
        post expert_recruit_unsubscriptions_url, params: { email: @expert_recruit.email, unsubscribe_token: @expert_recruit.unsubscribe_token }
      end
    end
  end
end
