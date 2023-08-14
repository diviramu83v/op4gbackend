# frozen_string_literal: true

require 'test_helper'

class Panelist::CleanIdsControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_confirmed_panelist
  end

  describe '#show' do
    it 'should load the page' do
      get clean_id_url(@panelist), params: { data: 'blank' }
      assert_redirected_to panelist_dashboard_path
    end

    it 'should suspend panelist if clean_id_failed' do
      Panelist.any_instance.expects(:clean_id_failed?).returns(true)
      get clean_id_url(@panelist), params: {}
      assert_not_nil @panelist.suspended_at
    end
  end
end
