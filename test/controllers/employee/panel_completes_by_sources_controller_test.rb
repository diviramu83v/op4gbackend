# frozen_string_literal: true

require 'test_helper'

class Employee::PanelCompletesBySourcesControllerTest < ActionDispatch::IntegrationTest
  before do
    load_and_sign_in_operations_employee
  end

  describe '#new' do
    it 'should load the page' do
      get new_panel_completes_by_sources_url

      assert_response :ok
    end
  end
end
