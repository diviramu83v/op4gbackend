# frozen_string_literal: true

require 'test_helper'

class Employee::RedirectLogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in employees(:admin)
    @project = projects(:standard)
  end

  describe '#index' do
    it 'should load the index page' do
      get project_redirect_issues_url(@project)

      assert_response :ok
    end
  end
end
