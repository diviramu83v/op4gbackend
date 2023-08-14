# frozen_string_literal: true

require 'test_helper'

class Panelist::ConfirmationsControllerTest < ActionDispatch::IntegrationTest
  it 'should get confirmation resend page' do
    get new_panelist_confirmation_url

    assert_response :success
  end

  it 'should be redirected to the dashboard after confirmation' do
    @panelist = Panelist.create(
      email: Faker::Internet.email,
      password: 'testing123',
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      country: Country.find_by(slug: 'us'),
      original_panel: Panel.find_by(slug: 'op4g-us'),
      primary_panel: Panel.find_by(slug: 'op4g-us'),
      address: Faker::Address.street_name,
      city: Faker::Address.city,
      state: Faker::Address.state_abbr,
      postal_code: Faker::Address.zip.first(5),
      birthdate: Date.new(1990, 1, 1),
      status: Panelist.statuses[:signing_up],
      clean_id_data: { data: 'blank' }
    )

    SignupReminder.expects(:create!).twice

    get panelist_confirmation_url(confirmation_token: @panelist.confirmation_token)

    assert_redirected_to dashboard_url
  end
end
