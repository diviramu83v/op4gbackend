# frozen_string_literal: true

require 'test_helper'

class Employee::UnsubscriptionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_admin
    @panelist = panelists(:standard)
    @invitation = project_invitations(:standard)
  end

  describe '#show' do
    it 'should load the page' do
      get unsubscriptions_url

      assert_response :ok
    end

    it 'should export csv' do
      get unsubscriptions_url(format: :csv)

      # check for csv response
      assert_equal controller.headers['Content-Transfer-Encoding'], 'binary'
    end
  end
end
