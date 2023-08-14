# frozen_string_literal: true

require 'test_helper'

class Panelist::NonprofitsControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_confirmed_panelist
  end

  it 'should update and delete the panelist\'s nonprofit' do
    nonprofit = nonprofits(:one)

    put account_nonprofit_url, params: { nonprofit_id: nonprofit.id }

    assert_equal @panelist.nonprofit, nonprofit
    assert_redirected_to account_contribution_url
  end

  it 'should remove the panelist\'s nonprofit' do
    nonprofit = nonprofits(:one)
    @panelist.nonprofit = nonprofit
    @panelist.save!

    assert_equal @panelist.nonprofit, nonprofit

    delete account_nonprofit_url

    assert @panelist.nonprofit.nil?
    assert_redirected_to account_contribution_url
  end
end
