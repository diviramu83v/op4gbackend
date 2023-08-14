# frozen_string_literal: true

require 'test_helper'

class Employee::DisqoQuotasControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in employees(:operations)
    @survey = surveys(:standard)
  end

  describe '#index' do
    setup do
      DisqoQuota.any_instance.stubs(:disqo_project_system_status).returns('OPEN')
    end

    it 'should load the page' do
      get survey_disqo_quotas_url(@survey)

      assert_response :ok
    end
  end

  describe '#new' do
    it 'should load the page' do
      get new_survey_disqo_quota_url(@survey)

      assert_response :ok
    end
  end

  describe '#edit' do
    setup do
      @disqo_quota = disqo_quotas(:standard)
    end

    it 'should load the page' do
      get edit_disqo_quota_url(@disqo_quota)

      assert_response :ok
    end
  end

  describe '#create' do
    setup do
      @params = {
        disqo_quota: {
          cpi: 1.55,
          loi: 10,
          conversion_rate: 30,
          completes_wanted: 2000,
          qualifications: {
            geocountry: 'US',
            gender: ['1'],
            age: { min_age: '18', max_age: '22' }
          }
        }
      }
    end

    it 'should build the qualifications hash' do
      DisqoApi.any_instance.stubs(:create_project).returns(nil)
      DisqoApi.any_instance.stubs(:create_project_quota).returns(nil)
      DisqoApi.any_instance.stubs(:update_project_status).returns(nil)

      assert_difference -> { DisqoQuota.count } do
        post survey_disqo_quotas_url(@survey), params: @params
      end

      assert_redirected_to survey_disqo_quotas_url(@survey)
    end

    it 'should fail to build the qualifications hash' do
      params = { disqo_quota: { cpi: '' } }
      assert_no_difference -> { DisqoQuota.count } do
        post survey_disqo_quotas_url(@survey), params: params
      end

      assert_template 'new'
    end

    it 'create disqo project without a quota present' do
      @survey.disqo_quotas.destroy_all
      DisqoApi.any_instance.stubs(:create_project).returns(nil)
      DisqoApi.any_instance.stubs(:create_project_quota).returns(nil)
      DisqoApi.any_instance.stubs(:update_project_status).returns(nil)

      assert_difference -> { DisqoQuota.count } do
        post survey_disqo_quotas_url(@survey), params: @params
      end

      assert_redirected_to survey_disqo_quotas_url(@survey)
    end
  end

  describe '#update' do
    setup do
      @disqo_quota = disqo_quotas(:standard)
      @params = {
        disqo_quota: {
          cpi: 1.55,
          completes_wanted: 2000,
          qualifications: {
            geocountry: 'US',
            gender: ['1'],
            age: { min_age: '18', max_age: '22' }
          }
        }
      }
    end

    it 'should update the quota' do
      url = Settings.disqo_api_url
      username = Settings.disqo_username
      quota_id = @disqo_quota.quota_id

      stub_request(
        :put,
        "#{url}/v1/clients/#{username}/projects/#{quota_id}"
      ).to_return(status: 200)

      stub_request(
        :put,
        "#{url}/v1/clients/#{username}/projects/#{quota_id}/quotas/#{quota_id}"
      ).to_return(status: 200)

      patch disqo_quota_url(@disqo_quota), params: @params

      assert_redirected_to survey_disqo_quotas_url(@survey)
    end

    it 'should fail to update the quota' do
      params = { disqo_quota: { cpi: '' } }
      patch disqo_quota_url(@disqo_quota), params: params

      assert_template 'edit'
    end
  end
end
