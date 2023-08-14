# frozen_string_literal: true

require 'test_helper'

class PanelistDashboardTest < ActionDispatch::IntegrationTest
  describe 'legacy panelist who is supporting a nonprofit' do
    setup do
      load_panelist

      add_panelist_nonprofit(panelist: @panelist, nonprofit: nonprofits(:one))
      add_panelist_legacy_earnings(panelist: @panelist)
      add_panelist_earnings(panelist: @panelist)
      add_panelist_payments(panelist: @panelist)

      sign_panelist_in panelist: @panelist
    end

    it 'can view their dashboard' do
      visit account_url

      assert page.has_content?('Earnings summary')
      assert page.has_content?('Earnings details')
      assert page.has_content?('Legacy')
    end
  end
end
