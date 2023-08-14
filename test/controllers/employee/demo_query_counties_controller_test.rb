# frozen_string_literal: true

require 'test_helper'

class Employee::DemoQueryCountiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_operations_employee

    @query = demo_queries(:standard)
    @county = counties(:standard)
  end

  describe 'create' do
    it 'creates a demo query county' do
      new_county = County.new
      new_county.save!
      post query_counties_url(@query, @county), params: { demo_query_county: { county_id: new_county.id } }

      assert_ok_with_no_warning
    end

    it 'should update the feasibility total when a feasibility query is created' do
      @feasibility_query = demo_queries(:feasibility_query)
      new_county = County.new
      new_county.save!

      post query_counties_url(@feasibility_query, @county), params: { demo_query_county: { county_id: new_county.id } }

      assert_ok_with_no_warning
      assert_not_nil DemoQueryCounty.last.demo_query.feasibility_total
    end
  end

  describe 'destroy' do
    it 'destroys a demo query county' do
      delete query_county_url(@query, @county)

      assert_ok_with_no_warning
    end
  end
end
