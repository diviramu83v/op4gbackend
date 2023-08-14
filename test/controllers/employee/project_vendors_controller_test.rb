# frozen_string_literal: true

require 'test_helper'

class Employee::ProjectVendorsControllerTest < ActionDispatch::IntegrationTest
  before do
    @project = projects(:standard)
    sign_in employees(:operations)
  end

  describe 'GET #new' do
    it 'renders correctly' do
      get new_project_vendor_url(@project)

      assert_response :ok
      assert_template :new
    end
  end

  describe 'POST #create' do
    before { @vendor = vendors(:batch) }

    describe 'valid ProjectVendor' do
      before do
        @complete_url = 'https://testing.com?complete'
        @terminate_url = 'https://testing.com?terminate'
        @overquota_url = 'https://testing.com?overquota'
        @params = { project_vendor: { vendor_id: @vendor.id, project_id: @project.id, incentive: 1.5, quoted_completes: 300, requested_completes: 300,
                                      complete_url: @complete_url, terminate_url: @terminate_url, overquota_url: @overquota_url } }
      end

      it 'creates a VendorBatch' do
        assert_difference -> { VendorBatch.count }, 1 do
          post project_vendors_url(@project), params: @params
        end
      end

      it 'redirects to project url' do
        post project_vendors_url(@project), params: @params
        assert_redirected_to project_url(@project)
      end
    end

    describe 'invalid ProjectVendor' do
      before do
        @params = { project_vendor: { vendor_id: @vendor.id, project_id: @project.id } }
      end

      it 'it does not create a VendorBatch' do
        assert_no_difference -> { VendorBatch.count } do
          post project_vendors_url(@project), params: @params
        end
      end

      it 'renders correctly' do
        post project_vendors_url(@project), params: @params

        assert_response :ok
        assert_template :new
      end
    end
  end
end
