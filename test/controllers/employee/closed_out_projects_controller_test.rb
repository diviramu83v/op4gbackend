# frozen_string_literal: true

require 'test_helper'

class Employee::ClosedOutProjectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_employee(:operations)
  end

  describe '#index' do
    it 'should load the page' do
      get closed_out_projects_url

      assert_response :ok
    end
  end
end
