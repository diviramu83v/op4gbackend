# frozen_string_literal: true

require 'simplecov'
require 'simplecov-lcov'
if ENV['CI'].present?
  SimpleCov::Formatter::LcovFormatter.config.report_with_single_file = true
  SimpleCov.formatter = SimpleCov::Formatter::LcovFormatter
end
SimpleCov.start 'rails' do
  add_filter '/app/channels/'
  add_filter '/app/controllers/table_data/'
  add_filter '/app/models/traffic_history_logger.rb'
  add_filter '/app/dashboards/'
  add_filter '/app/jobs/clock'
  add_filter '/app/mailers'
  add_filter '/lib/scripts'
  add_filter '/vendor/' # exclude vendor files on Heroku CI
end

require File.expand_path('../config/environment', __dir__)
require 'rails/test_help'
require 'mocha/minitest'
require 'webmock/minitest'
require 'sidekiq/testing'
require 'faker'
require 'capybara/rails'
require 'capybara/minitest'
require 'support/session_helpers'
require 'minitest/autorun'

WebMock.disable_net_connect!
Sidekiq::Testing.fake!
Mocha.configure { |c| c.stubbing_non_existent_method = :prevent }
Mocha.configure { |c| c.stubbing_non_public_method = :prevent }
Mocha.configure { |c| c.stubbing_method_unnecessarily = :prevent }

# Add Devise helpers to all integration tests.
class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  include SessionHelpers
end

class ActiveSupport::TestCase
  fixtures :all

  # enables parallel testing
  # parallelize(workers: 2)

  def load_query
    @query = demo_queries(:standard)
  end

  def load_no_country_query
    @query = demo_queries(:standard)
    @query.update(country: nil)
  end

  def load_no_option_query
    @query = demo_queries(:standard)
    @query.update(
      country: Country.create(name: 'United States', slug: 'us'),
      demo_query_options: []
    )
  end

  def load_and_sign_in_base_employee
    @employee = employees(:no_role)

    assert_empty @employee.roles

    sign_in @employee
  end

  def load_and_sign_in_admin
    @employee = employees(:admin)

    sign_in @employee
  end

  def load_and_sign_in_panelist_editor_employee
    @employee = employees(:panelist_editor)

    sign_in @employee
  end

  def load_and_sign_in_operations_employee
    @employee = employees(:operations)

    sign_in @employee
  end

  def load_and_sign_in_employee(role)
    sign_out(@employee) if @employee.present?

    @employee = employees(role)

    sign_in @employee
  end

  def load_and_sign_in_recruitment_employee
    @employee = employees(:recruitment)

    sign_in @employee
  end

  def load_and_sign_in_sales_employee
    @employee = employees(:sales)

    sign_in @employee
  end

  def load_and_sign_in_security_employee
    @employee = employees(:security)

    sign_in @employee
  end

  # rubocop:disable Metrics/MethodLength
  def confirm_panelist!(panelist)
    panel = panels(:standard)
    panelist.update!(
      confirmed_at: 3.hours.ago,
      agreed_to_terms_at: 2.hours.ago,
      welcomed_at: 1.hour.ago,
      status: Panelist.statuses[:active],
      original_panel: panel,
      primary_panel: panel,
      address: Faker::Address.street_name,
      city: Faker::Address.city,
      state: Faker::Address.state_abbr,
      postal_code: Faker::Address.zip,
      birthdate: Date.new(1990, 1, 1)
    )
  end
  # rubocop:enable Metrics/MethodLength

  def load_and_sign_in_panelist(panelist = nil)
    @panelist = panelist || panelists(:standard)
    sign_in @panelist
  end

  def load_and_sign_in_confirmed_panelist
    @panelist = panelists(:standard)
    @panelist.update_columns( # rubocop:disable Rails/SkipsModelValidations
      confirmed_at: 3.hours.ago,
      agreed_to_terms_at: 2.hours.ago,
      welcomed_at: 1.hour.ago
    )
    sign_in @panelist
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def load_and_sign_in_confirmed_panelist_with_base_info
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
      address: '123 Test St.',
      city: 'Testcity',
      state: 'CA',
      postal_code: 111_11,
      birthdate: '2000-01-01',
      status: Panelist.statuses[:signing_up],
      clean_id_data: { data: 'blank' },
      primary_panel: panel,
      original_panel: panel,
      confirmed_at: 3.hours.ago,
      agreed_to_terms_at: 2.hours.ago,
      welcomed_at: 1.hour.ago
    )
    sign_in @panelist
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  def assert_ok_with_no_warning
    assert_response :ok
    assert_nil flash[:alert]
    assert_nil flash[:notice]
  end

  def assert_response_with_warning
    assert_response :ok
    assert_not_nil flash[:alert]
  end

  def assert_redirected_with_no_warning
    assert_response :redirect
    assert_nil flash[:alert]
  end

  def assert_redirected_with_warning
    assert_response :redirect
    assert_not_nil flash[:alert]
  end

  def assert_redirected_with_notice
    assert_response :redirect
    assert_nil flash[:alert]
    assert_not_nil flash[:notice]
  end

  def assert_panelist_signin_required
    assert_redirected_to new_panelist_session_url
    assert_not_nil flash[:alert]
  end

  def assert_panelist_already_signed_in
    assert_redirected_to panelist_dashboard_url
    assert_not_nil flash[:alert]
  end

  def assert_employee_signin_required
    assert_redirected_to new_employee_session_url
    assert_not_nil flash[:alert]
  end

  def assert_employee_already_signed_in
    assert_redirected_to employee_dashboard_url
    assert_not_nil flash[:alert]
  end

  def setup_live_survey(base_link: nil)
    base_link ||= "#{Faker::Internet.url}?pid={{uid}}"

    project = projects(:standard)
    survey = project.add_survey
    survey.update!(base_link: base_link, loi: 15, target: 450, cpi_cents: 1700, audience: 'audience', country_id: 284_678_023)

    survey_response_urls = survey_response_urls(:complete)
    survey_response_urls.update!(project: project)

    survey
  end

  def stub_disqo_project_and_quota_status_change
    stub_request(:put, 'https://projects-api.audience.disqo-demo.com/v1/clients/97924/projects/1/quotas/1/status')
      .to_return(status: 200, body: '', headers: {})
    stub_request(:put, 'https://projects-api.audience.disqo-demo.com/v1/clients/97924/projects/1/status')
      .to_return(status: 200, body: '', headers: {})
  end

  def refute_select(selector, text)
    assert_select selector, count: 0, text: text
  end

  def skip_in_ci
    return skip if ENV['CI'].present?
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :minitest
    with.library :rails
  end
end
