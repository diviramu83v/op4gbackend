# frozen_string_literal: true

require 'test_helper'

class Employee::CintSurveysControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_admin
    @survey = surveys(:standard)
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
      cint_survey: {
        loi: 20,
        limit: 100,
        expected_incidence_rate: 100,
        name: 'Test Survey',
        cint_country_id: 22
      },
      options: {
        number_of_children: ['4']
      }
    }
  end

  describe '#index' do
    it 'should load the page' do
      stub_request(:get, 'https://fuse.cint.com/ordering/reference/questions?countryId=22').to_return(status: 200,
                                                                                                      body: '[{"id":4,"name":"Number of children",
                                                                                                              "variables":[{"id":2,"name":"None"},
                                                                                                              {"id":3,"name":"One"}]}]',
                                                                                                      headers: { 'Content-Type' => 'application/json' })
      get survey_cint_surveys_url(@survey)

      assert_response :ok
    end
  end

  describe '#new' do
    it 'should load the page' do
      CintApi.any_instance.stubs(:countries_hash).returns(@return_body)
      get new_survey_cint_survey_url(@survey)

      assert_response :ok
    end
  end

  describe '#edit' do
    setup do
      @cint_survey = cint_surveys(:standard)
    end

    it 'should load the page' do
      get edit_cint_survey_url(@cint_survey)

      assert_response :ok
    end
  end

  describe '#create' do
    setup do
      CintApi.any_instance.stubs(:countries_hash).returns(@return_body)
    end

    it 'should create a cint_survey with status of draft' do
      stub_request(:post, 'https://fuse.cint.com/webhooks').to_return(status: 200, body: '', headers: {})
      assert_difference -> { CintSurvey.count } do
        post survey_cint_surveys_url(@survey), params: @params
      end

      assert_equal CintSurvey.last.status, 'draft'
    end

    it 'should not create a cint_survey with loi over 36' do
      @params[:cint_survey].merge!(loi: 37)

      assert_no_difference -> { CintSurvey.count } do
        post survey_cint_surveys_url(@survey), params: @params
      end
    end

    it 'should not create a cint_survey with incidence_rate over 100' do
      @params[:cint_survey].merge!(expected_incidence_rate: 101)

      assert_no_difference -> { CintSurvey.count } do
        post survey_cint_surveys_url(@survey), params: @params
      end
    end

    it 'should create a cint_survey' do
      @params[:cint_survey].merge!(postal_codes: '90011,
                                   91331,
                                   90650,
                                   90805')

      assert_difference -> { CintSurvey.count } do
        post survey_cint_surveys_url(@survey), params: @params
      end
    end

    it 'should create a cint onramp' do
      stub_request(:post, 'https://fuse.cint.com/webhooks').to_return(status: 200, body: '', headers: {})
      assert_difference -> { Onramp.cint.count } do
        post survey_cint_surveys_url(@survey), params: @params
      end
    end

    it 'should render new' do
      @params[:cint_survey].merge!(limit: '')
      post survey_cint_surveys_url(@survey), params: @params

      assert_template :new
    end
  end

  describe '#update' do
    setup do
      @cint_survey = cint_surveys(:standard)
      @params = {
        cint_survey: {
          cpi: 100,
          limit: 150
        }
      }
      @bad_params = {
        cint_survey: {
          limit: nil
        }
      }
    end

    it 'should update cpi' do
      stub_request(:patch, 'https://fuse.cint.com/ordering/surveys/227').to_return(status: 200)

      patch cint_survey_url(@cint_survey), params: @params
      @cint_survey.reload

      assert_equal 100, @cint_survey.cpi.to_i
    end

    it 'should update limit' do
      stub_request(:patch, 'https://fuse.cint.com/ordering/surveys/227').to_return(status: 200)

      patch cint_survey_url(@cint_survey), params: @params
      @cint_survey.reload

      assert_equal 150, @cint_survey.limit
    end

    it 'should not update' do
      patch cint_survey_url(@cint_survey), params: @bad_params

      assert_not_nil @cint_survey.errors
    end

    it 'should not update with an invalid cpi' do
      minimum_cpi = CintCpiCalculator.new(loi: @cint_survey.loi, incidence_rate: @cint_survey.expected_incidence_rate).calculate!
      invalid_cpi = minimum_cpi - 100
      params = { cint_survey: { cpi: invalid_cpi, limit: 150 } }
      patch cint_survey_url(@cint_survey), params: params

      assert_not_nil @cint_survey.errors
    end
  end
end
