# frozen_string_literal: true

require 'test_helper'

class Employee::FeasibilitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in employees(:sales)
  end

  describe '#index' do
    it 'should load the page' do
      get feasibilities_url
      assert_response :ok
    end

    it 'should load the page with employee' do
      employee = employees(:operations)
      get feasibilities_url, params: { employee_id: employee.id }
      assert_response :ok
    end
  end

  describe '#new' do
    it 'should load the page' do
      get new_feasibility_url
      assert_response :ok
    end
  end

  describe '#show' do
    setup do
      @demo_query = demo_queries(:standard)
    end

    it 'should load the page' do
      get feasibility_url(@demo_query)
    end
  end

  describe '#create' do
    setup do
      @panel = panels(:standard)
    end

    it 'should successfully create a demo query' do
      assert_difference -> { DemoQuery.count } do
        post feasibilities_url({ feasibility: { panel_id: @panel.id } })
      end

      assert_not_nil DemoQuery.last.feasibility_total
    end

    it 'should fail to create a demo query' do
      assert_no_difference -> { DemoQuery.count } do
        post feasibilities_url({ feasibility: { panel_id: '' } })
      end

      assert_nil DemoQuery.last.feasibility_total
    end
  end
end
