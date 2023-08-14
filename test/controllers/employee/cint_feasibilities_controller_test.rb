# frozen_string_literal: true

require 'test_helper'

class Employee::CintFeasibilitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @employee = employees(:recruitment)
    sign_in(@employee)
    @return_body = [
      {
        'id' => 22,
        'name' => 'USA',
        'regionTypes' => [
          {
            'id' => 1,
            'regions' => []
          },
          {
            'id' => 2,
            'regions' => []
          },
          {
            'id' => 3,
            'regions' => []
          },
          {
            'id' => 4,
            'regions' => [{ 'id' => 1, 'name' => 'California' }, { 'id' => 2, 'name' => 'New York' }]
          },
          {
            'id' => 5,
            'regions' => [{ 'id' => 1, 'name' => 'Los Angeles' }, { 'id' => 2, 'name' => 'New York' }]
          }
        ]
      }
    ]
    @params = {
      cint_feasibility: {
        loi: 20,
        days_in_field: 2,
        limit: 100,
        incidence_rate: 100,
        cint_country_id: 22
      },
      options: {
        number_of_children: ['4']
      }
    }
  end

  describe '#index' do
    test 'load the page' do
      stub_request(:get, 'https://fuse.cint.com/ordering/reference/questions?countryId=22').to_return(status: 200,
                                                                                                      body: '[{"id":4,"name":"Number of children",
                                                                                                              "variables":[{"id":2,"name":"None"},
                                                                                                              {"id":3,"name":"One"}]}]',
                                                                                                      headers: { 'Content-Type' => 'application/json' })
      stub_request(:get, 'https://fuse.cint.com/ordering/reference/countries').to_return(status: 200)

      get cint_feasibilities_url

      assert_response :ok
    end
  end

  describe '#new' do
    test 'load the page' do
      CintApi.any_instance.stubs(:countries_hash).returns(@return_body)
      stub_request(:get, 'https://api.cintworks.net/ordering/reference/countries').to_return(status: 200)

      get new_cint_feasibility_url

      assert_response :ok
    end
  end

  describe '#create' do
    setup do
      CintApi.any_instance.stubs(:countries_hash).returns(@return_body)
    end

    it 'should create a cint_feasibility' do
      CintApi.any_instance.expects(:create_survey_feasibility).returns(185_000)

      assert_difference -> { CintFeasibility.count } do
        post cint_feasibilities_url, params: @params
      end
    end

    it 'should not create a cint_feasibility with loi over 36' do
      @params[:cint_feasibility].merge!(loi: 37)

      assert_no_difference -> { CintFeasibility.count } do
        post cint_feasibilities_url, params: @params
      end
    end

    it 'should not create a cint_feasibility with incidence_rate over 100' do
      @params[:cint_feasibility].merge!(incidence_rate: 101)

      assert_no_difference -> { CintFeasibility.count } do
        post cint_feasibilities_url, params: @params
      end
    end

    it 'should populate number of panelists' do
      CintApi.any_instance.expects(:create_survey_feasibility).returns(185_000)

      post cint_feasibilities_url, params: @params
      assert_equal 185_000, CintFeasibility.last.number_of_panelists
    end

    it 'should render new' do
      @params[:cint_feasibility].merge!(days_in_field: '')
      post cint_feasibilities_url, params: @params
      assert_template :new
    end
  end
end
