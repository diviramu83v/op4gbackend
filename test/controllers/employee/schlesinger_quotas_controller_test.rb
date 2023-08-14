# frozen_string_literal: true

require 'test_helper'

class Employee::SchlesingerQuotasControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_admin
    @survey = surveys(:standard)
    @industries_return_body = [{ 'industryId' => 1, 'description' => 'Automotive' }, { 'industryId' => 2, 'description' => 'Beauty/Cosmetics' }]
    @study_types_return_body = [{ 'studyTypeId' => 1, 'description' => 'Online Survey – Adhoc' }, { 'studyTypeId' => 2, 'description' => 'Online Diary' }]
    @sample_types_return_body = [{ 'sampleTypeId' => 1, 'description' => 'B2B' }, { 'sampleTypeId' => 2, 'description' => 'Consumer' }]
    @qualifications_return_body = [{ qualificationId: 59, name: 'Age', text: 'What is your age?', qualificationCategoryId: 5,
                                     qualificationTypeId: 6, answers: %w[21 22] }]
  end

  describe '#index' do
    it 'should load the page' do
      get survey_schlesinger_quotas_url(@survey)

      assert_response :ok
    end
  end

  describe '#new' do
    it 'should load the page' do
      SchlesingerApi.any_instance.stubs(:industries).returns(@industries_return_body)
      SchlesingerApi.any_instance.stubs(:study_types).returns(@study_types_return_body)
      SchlesingerApi.any_instance.stubs(:sample_types).returns(@sample_types_return_body)
      get new_survey_schlesinger_quota_url(@survey)

      assert_response :ok
    end
  end

  describe '#edit' do
    setup do
      @schlesinger_quota = schlesinger_quotas(:standard)
    end

    it 'should load the page' do
      SchlesingerApi.any_instance.stubs(:industries).returns(@industries_return_body)
      SchlesingerApi.any_instance.stubs(:study_types).returns(@study_types_return_body)
      SchlesingerApi.any_instance.stubs(:sample_types).returns(@sample_types_return_body)
      get edit_schlesinger_quota_url(@schlesinger_quota)

      assert_response :ok
    end
  end

  describe '#create' do
    setup do
      Sidekiq::Testing.inline!
      @params = {
        schlesinger_quota: {
          cpi: 10,
          loi: 30,
          soft_launch_completes_wanted: 10,
          completes_wanted: 40,
          conversion_rate: 30,
          industry_id: 1,
          study_type_id: 1,
          sample_type_id: 1,
          start_date_time: '2022-10-07',
          end_date_time: '2022-10-14',
          qualifications: {
            age: { min_age: '19', max_age: '25' },
            gender: ['1']
          }
        }
      }
      SchlesingerApi.any_instance.stubs(:industries).returns(@industries_return_body)
      SchlesingerApi.any_instance.stubs(:study_types).returns(@study_types_return_body)
      SchlesingerApi.any_instance.stubs(:sample_types).returns(@sample_types_return_body)
      SchlesingerApi.any_instance.stubs(:create_project).returns(1)
      SchlesingerApi.any_instance.stubs(:create_survey).returns(1)
      SchlesingerApi.any_instance.stubs(:create_qualifications).returns(@qualifications_return_body)
      SchlesingerApi.any_instance.stubs(:create_quota).returns(1)
      SchlesingerApi.any_instance.stubs(:get_survey_status).returns(1)
      SchlesingerApi.any_instance.stubs(:get_survey_name).returns('Test Survey')
    end

    it 'should create a schlesinger_quota and redirect to the schlesinger_quotas index page ' do
      assert_difference -> { SchlesingerQuota.count } do
        post survey_schlesinger_quotas_url(@survey), params: @params
      end
      assert_redirected_to survey_schlesinger_quotas_url(@survey)
    end
  end

  describe '#update' do
    setup do
      @schlesinger_quota = schlesinger_quotas(:standard)
      @params = { schlesinger_quota: { cpi: 10, loi: 30, soft_launch_completes_wanted: 10, completes_wanted: 40, conversion_rate: 30, industry_id: 1,
                                       study_type_id: 1, sample_type_id: 1, start_date_time: '2022-10-07', end_date_time: '2022-10-14' } }
    end

    it 'should update the quota' do
      SchlesingerApi.any_instance.stubs(:industries).returns(@industries_return_body)
      SchlesingerApi.any_instance.stubs(:study_types).returns(@study_types_return_body)
      SchlesingerApi.any_instance.stubs(:sample_types).returns(@sample_types_return_body)
      SchlesingerApi.any_instance.stubs(:update_survey).returns(nil)

      put schlesinger_quota_url(@schlesinger_quota), params: @params

      assert_redirected_to survey_schlesinger_quotas_url(@survey)
    end

    it 'should fail to update the quota' do
      params = { schlesinger_quota: { cpi: '', loi: 30, soft_launch_completes_wanted: 10, completes_wanted: 40, conversion_rate: 30, industry_id: 1,
                                      study_type_id: 1, sample_type_id: 1, start_date_time: '2022-10-07 00:00:00', end_date_time: '2022-10-14 23:59:59' } }
      SchlesingerApi.any_instance.stubs(:industries).returns(@industries_return_body)
      SchlesingerApi.any_instance.stubs(:study_types).returns(@study_types_return_body)
      SchlesingerApi.any_instance.stubs(:sample_types).returns(@sample_types_return_body)

      put schlesinger_quota_url(@schlesinger_quota), params: params

      assert_template 'edit'
    end
  end
end
