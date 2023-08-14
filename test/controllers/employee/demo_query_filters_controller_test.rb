# frozen_string_literal: true

require 'test_helper'

class Employee::DemoQueryFiltersControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_operations_employee
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def check_relations_presence(query)
    assert query.country.present?
    assert query.options.present?
    assert query.demo_query_state_codes.present?
    assert query.ages.present?
    assert query.regions.present?
    assert query.divisions.present?
    assert query.states.present?
    assert query.dmas.present?
    assert query.msas.present?
    assert query.pmsas.present?
    assert query.counties.present?
    assert query.zip_codes.present?
    assert query.project_inclusions.present?
    assert query.encoded_uid_onboardings.present?
  end

  def check_relations_empty(query)
    assert query.country.nil?
    assert query.options.empty?
    assert query.demo_query_state_codes.empty?
    assert query.ages.empty?
    assert query.regions.empty?
    assert query.divisions.empty?
    assert query.states.empty?
    assert query.dmas.empty?
    assert query.msas.empty?
    assert query.pmsas.empty?
    assert query.counties.empty?
    assert query.zip_codes.empty?
    assert query.project_inclusions.empty?
    assert query.encoded_uid_onboardings.empty?
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  describe '#destroy' do
    it 'should remove the demo query and all relations before returning the
        demo query ' do
      query = demo_queries(:standard)

      check_relations_presence(query)

      delete query_filter_url(query)

      query.reload
      check_relations_empty(query)

      assert response.body['filter']
      assert_response :ok
    end

    it 'should remove the demo query and all relations' do
      query = demo_queries(:standard)

      check_relations_presence(query)

      delete query_filter_url(query), params: { source: 'demo_query_options' }

      query.reload
      check_relations_empty(query)

      assert response.body['filter']
      assert_response :ok
    end

    it 'should remove the demo query and all relations' do
      query = demo_queries(:standard)

      check_relations_presence(query)

      delete query_filter_url(query), params: { source: 'demo_query_zip_codes' }

      query.reload
      check_relations_empty(query)

      assert response.body['filter']
      assert_response :ok
    end
  end
end
