# frozen_string_literal: true

require 'test_helper'

class Panelist::AcceptTermsAndConditionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_confirmed_panelist
  end

  it 'should get the \'Accept Terms and Conditions\' page' do
    get accept_terms_and_conditions_url

    assert_ok_with_no_warning
  end

  it 'should redirect to dashboard and populate the panelist\'s \'agreed_to_terms_at\' column' do
    @panelist.update!(agreed_to_terms_at: nil)

    post accept_terms_and_conditions_url

    assert @panelist.agreed_to_terms_at.present?
    assert_redirected_to panelist_dashboard_url
  end
end
