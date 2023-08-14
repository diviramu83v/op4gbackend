# frozen_string_literal: true

require 'test_helper'

class Employee::VendorBatchesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @survey = surveys(:standard)

    sign_in employees(:operations)
  end

  describe '#new' do
    it 'renders correctly' do
      get new_survey_vendor_url(@survey)

      assert_response :ok
      assert_template :new
    end
  end

  describe '#create' do
    it 'create vendor batch' do
      @vendor = vendors(:batch)

      @params = { vendor_batch: { vendor_id: @vendor.id, incentive: 1.5, quoted_completes: 300, requested_completes: 300 } }

      assert_difference -> { VendorBatch.count } do
        post survey_vendors_url(@survey), params: @params
      end
    end

    # TODO: Rework this test to make sure there's only one batch per vendor.
    it 'vendor batch creates onramp that matches the vendor gate survey default' do
      @vendor_one = vendors(:batch)
      @vendor_two = vendors(:api)

      @params_one = { vendor_batch: { vendor_id: @vendor_one.id, incentive: 1.5, quoted_completes: 300, requested_completes: 300 } }
      @params_two = { vendor_batch: { vendor_id: @vendor_two.id, incentive: 1.5, quoted_completes: 300, requested_completes: 300 } }

      @vendor_one.update!(gate_survey_on_by_default: true)
      post survey_vendors_url(@survey), params: @params_one
      assert @vendor_one.vendor_batches.last.onramp.check_gate_survey

      @vendor_one.update!(gate_survey_on_by_default: false)
      post survey_vendors_url(@survey), params: @params_two
      assert_not @vendor_two.vendor_batches.last.onramp.check_gate_survey
    end

    it 'fail vendor batch creation' do
      vendors(:batch)

      @params = { vendor_batch: { vendor_id: -1 } }

      assert_no_difference -> { VendorBatch.count } do
        post survey_vendors_url(@survey), params: @params
      end
    end

    it 'requires that a vendor be selected when a batch creation is attempted' do
      vendors(:batch)

      @params = { vendor_batch: { incentive: 1.5 } }

      assert_no_difference -> { VendorBatch.count } do
        post survey_vendors_url(@survey), params: @params
      end

      assert_template :new
    end

    it 'should ignore ActiveRecord::RecordNotUnique' do
      @vendor = vendors(:batch)

      @params = { vendor_batch: { vendor_id: @vendor.id, incentive: 1.5, quoted_completes: 300, requested_completes: 300 } }

      post survey_vendors_url(@survey), params: @params
      post survey_vendors_url(@survey), params: @params

      assert_redirected_to survey_vendors_url(@survey, anchor: "vendor-#{@vendor.id}")
    end
  end

  describe '#edit' do
    setup do
      @batch = vendor_batches(:standard)
    end

    it 'renders the edit view' do
      get edit_vendor_batch_url(@batch)

      assert_ok_with_no_warning
      assert_template :edit
    end
  end

  describe '#update' do
    setup do
      @batch = vendor_batches(:standard)
    end

    it 'updates the vendor batch with the provided params and redirects to the campaign step url' do
      put vendor_batch_url(@batch), params: { vendor_batch: { incentive: 100 } }

      assert_redirected_to survey_vendors_url(@batch, anchor: "vendor-#{@batch.vendor.id}")
    end

    it 'renders the edit view if the vendor batch update failed' do
      put vendor_batch_url(@batch), params: { vendor_batch: { incentive: -100 } }

      assert_ok_with_no_warning
      assert_template :edit
    end

    it 'enables the onramp' do
      @batch.onramp.update!(disabled_at: Time.now.utc)
      assert_not_nil @batch.onramp.disabled_at

      put vendor_batch_url(@batch), params: { vendor_batch: { requested_completes: 1 } }

      @batch.reload
      assert_nil @batch.onramp.disabled_at
    end
  end

  describe '#destroy' do
    setup do
      @batch = vendor_batches(:standard)
    end

    it 'deletes the provided vendor batch' do
      assert_difference -> { VendorBatch.count }, -1 do
        delete vendor_batch_url(@batch)
      end
    end

    it 'alerts that the vendor was not removed if unable' do
      VendorBatch.any_instance.stubs(:deletable?).returns(false)

      assert_no_difference -> { VendorBatch.count } do
        delete vendor_batch_url(@batch)
      end
    end
  end
end
