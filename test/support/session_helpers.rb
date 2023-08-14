# frozen_string_literal: true

require 'test_helper'

module SessionHelpers
  include Capybara::DSL

  def load_panelist # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    panel = Panel.create(
      name: Faker::Name.unique.first_name,
      slug: Faker::Name.unique.first_name.downcase,
      country: Country.create(name: 'United States', slug: 'us')
    )
    @panelist = Panelist.create(
      email: Faker::Internet.email,
      password: 'testing123',
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      country: Country.find_by(slug: 'us'),
      original_panel: panel,
      primary_panel: panel,
      address: '123 Test St.',
      city: 'Testcity',
      state: 'CA',
      postal_code: 111_11,
      birthdate: '2000-01-01',
      status: Panelist.statuses[:signing_up],
      clean_id_data: { data: 'blank' },
      confirmed_at: 3.hours.ago,
      agreed_to_terms_at: 2.hours.ago,
      welcomed_at: 1.hour.ago
    )
  end

  def load_operations_employee
    @employee = employees(:operations)
    @employee.update!(password: 'testing123')
  end

  def sign_panelist_in(panelist:)
    visit new_panelist_session_url
    fill_in 'Email', with: panelist.email
    fill_in 'Password', with: 'testing123'
    click_button 'Sign in'
  end

  def sign_employee_in(employee:)
    visit new_employee_session_url
    fill_in 'Email', with: employee.email
    fill_in 'Password', with: 'testing123'
    click_button 'Sign in'
  end

  def add_panelist_nonprofit(panelist:, nonprofit:)
    panelist.update!(nonprofit: nonprofit, donation_percentage: 75)
    assert panelist.supporting_nonprofit?
  end

  def add_panelist_legacy_earnings(panelist:)
    panelist.update!(legacy_earnings: 100)
    assert_not panelist.legacy_earnings.blank?
    assert_not panelist.legacy_earnings.zero?
  end

  def add_panelist_earnings(panelist:)
    3.times do
      panelist.earnings << Earning.create(
        panelist: panelist,
        total_amount: Faker::Number.decimal(l_digits: 2, r_digits: 2)
      )
    end
    assert_equal 3, panelist.earnings.count
  end

  def add_panelist_payments(panelist:)
    3.times do
      panelist.payments << Payment.create(
        panelist: panelist,
        amount_cents: 100,
        paid_at: Time.zone.now,
        period: Time.zone.now,
        period_year: Time.zone.now.year
      )
    end
    assert_equal 3, panelist.payments.count
  end
end
