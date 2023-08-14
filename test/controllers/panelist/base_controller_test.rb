# frozen_string_literal: true

require 'test_helper'

class Panelist::BaseControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_confirmed_panelist_with_base_info
    @nonprofit = nonprofits(:one)
  end

  it 'should display the \'inactive\' notice if the panelist\'s nonprofit is archived' do
    @nonprofit.update!(archived_at: Time.now.utc - 1.day)
    @panelist.update!(archived_nonprofit: @nonprofit)

    get panelist_dashboard_url

    assert_response :ok
    assert_not_nil flash[:notice]
  end

  it 'should skip the \'inactive\' notice if the panelist\'s nonprofit is archived past the cutoff' do
    @nonprofit.update!(archived_at: Time.now.utc - 45.days)
    @panelist.update!(archived_nonprofit: @nonprofit)

    get panelist_dashboard_url

    assert_ok_with_no_warning
  end

  it 'should skip the \'inactive\' notice if the panelist\'s nonprofit not archived' do
    @nonprofit.update!(archived_at: Time.now.utc - 45.days)

    get panelist_dashboard_url

    assert_ok_with_no_warning
  end
end
