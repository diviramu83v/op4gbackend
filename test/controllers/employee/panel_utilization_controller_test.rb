# frozen_string_literal: true

require 'test_helper'

class Employee::PanelUtilizationControllerTest < ActionDispatch::IntegrationTest
  before do
    load_and_sign_in_recruitment_employee
    @panel = panels(:standard)
  end

  describe '#show' do
    it 'should load the show page' do
      get panel_utilization_url(@panel)

      assert_response :ok
    end
  end
end
