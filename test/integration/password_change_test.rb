# frozen_string_literal: true

require 'test_helper'

class PasswordChangeTest < ActionDispatch::IntegrationTest
  setup do
    @new_password = Faker::Internet.password(min_length: 8)
    panel = Panel.create(
      name: Faker::Company.name,
      slug: Faker::Internet.slug,
      country: Country.create(name: 'United States', slug: 'us')
    )
    @panelist = Panelist.create(
      email: Faker::Internet.email,
      password: 'RKSv-JT9oVW3nYpnOQkcVQ',
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      country: Country.find_by(slug: 'us'),
      original_panel: panel,
      primary_panel: panel,
      address: Faker::Address.street_name,
      city: Faker::Address.city,
      state: Faker::Address.state_abbr,
      postal_code: Faker::Address.zip.first(5),
      birthdate: Date.new(1990, 1, 1),
      status: Panelist.statuses[:signing_up],
      clean_id_data: { data: 'blank' },
      confirmed_at: 1.hour.ago,
      agreed_to_terms_at: 3.days.ago,
      welcomed_at: 1.day.ago
    )
  end

  it 'hashes and checks changed passwords correctly' do
    # log in with the old / current info
    post panelist_session_url,
         params: { panelist: { email: @panelist.email, password: 'RKSv-JT9oVW3nYpnOQkcVQ', remember_me: '0' } }

    # make sure log in succeeded and we're at the dashboard
    assert_redirected_to panelist_dashboard_url

    # update the password to the new password
    post account_private_url,
         params: { panelist: { current_password: 'RKSv-JT9oVW3nYpnOQkcVQ', new_password: @new_password, password_confirmation: @new_password } }

    # log out
    delete destroy_panelist_session_url

    # make sure we're logged out and at the sign-in screen
    assert_redirected_to new_panelist_session_url

    # attempt to log in with the old password
    post panelist_session_url,
         params: { panelist: { email: @panelist.email, password: 'RKSv-JT9oVW3nYpnOQkcVQ', remember_me: '0' } }

    # make sure we are rendered back to the sign-in screen
    assert_response_with_warning

    # attempt to log in with the new password
    post panelist_session_url,
         params: { panelist: { email: @panelist.email, password: @new_password, remember_me: '0' } }

    # make sure the login was successful and we're on the dashboard page
    assert_redirected_to panelist_dashboard_url

    # log out in prep for the next test
    delete destroy_panelist_session_url
  end
end
