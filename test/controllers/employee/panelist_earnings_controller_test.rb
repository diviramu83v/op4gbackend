# frozen_string_literal: true

require 'test_helper'

class Employee::PanelistEarningsControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_employee(:operations)
    @project = projects(:standard)
    @invitation = project_invitations(:standard)
  end

  describe '#index' do
    it 'should load the index page' do
      get project_panelist_earnings_url(@project)

      assert_response :ok
    end
  end

  describe '#create' do
    describe 'success' do
      it 'adds earnings records successfully' do
        Earning.delete_all

        onboarding = onboardings(:complete)
        onboarding.project_invitation = @invitation
        onboarding.onramp = onramps(:panel)
        onboarding.client_status = :accepted
        onboarding.save!

        assert_difference -> { Earning.count } do
          post project_panelist_earnings_url(@project)
        end

        @project.reload

        assert_redirected_to project_close_out_url(@project)
      end
    end
  end
end
