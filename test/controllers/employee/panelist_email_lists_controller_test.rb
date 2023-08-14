# frozen_string_literal: true

require 'test_helper'

class Employee::PanelControllerTest < ActionDispatch::IntegrationTest
  setup do
    @employee = employees(:admin)
    sign_in(@employee)

    @panel = panels(:standard)
  end

  describe '#show' do
    it 'load the partial' do
      get "#{panel_email_lists_url(@panel)}.js"

      assert_response :ok
    end
  end
end
