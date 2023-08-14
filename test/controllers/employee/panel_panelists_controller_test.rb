# frozen_string_literal: true

require 'test_helper'

class Employee::PanelPanelistsControllerTest < ActionDispatch::IntegrationTest
  before do
    load_and_sign_in_panelist_editor_employee
    @panel = panels(:standard)
  end

  describe '#index' do
    it 'should load the index page' do
      get panel_panelists_url(@panel)

      assert_response :ok
    end

    it 'returns a csv of the results' do
      get panel_panelists_url(@panel, format: :csv)

      assert_response :ok
    end

    test 'panelists screened' do
      get panel_panelists_url(@panel), params: { panelists: 'screened' }

      assert_response :ok
    end

    test 'panelists no invitation' do
      get panel_panelists_url(@panel), params: { panelists: 'no_invitations' }

      assert_response :ok
    end
  end
end
