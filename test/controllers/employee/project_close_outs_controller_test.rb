# frozen_string_literal: true

require 'test_helper'

class Employee::ProjectCloseOutsControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_employee(:operations)
  end

  describe '#index' do
    it 'should load the page' do
      get project_close_outs_url

      assert_response :ok
    end
  end
end
