# frozen_string_literal: true

require 'test_helper'

class Employee::DemographicDetailsControllerTest < ActionDispatch::IntegrationTest
  before do
    load_and_sign_in_admin
  end

  setup do
    @demographic_detail = demographic_details(:standard)
    onboarding = onboardings(:complete)
    panel = panels(:standard)
    onboarding.update!(panel: panel)
  end

  describe '#new' do
    it 'should load the page' do
      get new_demographic_detail_url

      assert_response :ok
    end
  end

  describe '#create' do
    it 'should create a demographic detail' do
      params = { demographic_detail: { upload_data: 'abcd' } }
      assert_difference -> { DemographicDetail.count } do
        post demographic_details_url, params: params
      end
    end

    it 'should redirect after save' do
      params = { demographic_detail: { upload_data: 'abcd' } }
      post demographic_details_url, params: params
      assert_response :redirect
    end

    it 'should fail to create a demographic detail' do
      params = { demographic_detail: { upload_data: ' ' } }
      assert_no_difference -> { DemographicDetail.count } do
        post demographic_details_url, params: params
      end
    end

    it 'should fail to create a demographic detail due to multiple panels' do
      second_onboarding = onboardings(:second)
      second_onboarding.panel = panels(:diabetes)
      params = { demographic_detail: { upload_data: "abc\nabcd" } }
      assert_no_difference -> { DemographicDetail.count } do
        post demographic_details_url, params: params
      end
    end
  end

  describe '#show' do
    it 'should return the generated csv' do
      get demographic_detail_url(@demographic_detail, format: :csv)
      assert_response :ok
      assert_equal 'text/csv', response.content_type
    end
  end
end
