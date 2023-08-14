# frozen_string_literal: true

require 'test_helper'

class Employee::SampleBatchClosingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_operations_employee
  end

  describe 'closing an open sample batch' do
    setup do
      @sample_batch = sample_batches(:standard)
    end

    it 'closes the batch' do
      assert_not @sample_batch.closed?

      post sample_batch_close_url(@sample_batch)
      @sample_batch.reload

      assert @sample_batch.closed?
    end

    it 'responds appropriately when successful' do
      post sample_batch_close_url(@sample_batch)

      assert_nil flash[:alert]
      assert_not_nil flash[:notice]
      assert_redirected_to survey_queries_url(@sample_batch.survey)
    end

    it 'responds appropriately after failure' do
      SampleBatch.any_instance.stubs(:close).returns(false)

      post sample_batch_close_url(@sample_batch)

      assert_not_nil flash[:alert]
      assert_nil flash[:notice]
      assert_redirected_to survey_queries_url(@sample_batch.survey)
    end
  end

  describe 're-opening a closed sample batch' do
    setup do
      @sample_batch = sample_batches(:standard)
      @sample_batch.close
    end

    it 're-opens the batch' do
      assert @sample_batch.closed?

      delete sample_batch_close_url(@sample_batch)
      @sample_batch.reload

      assert_not @sample_batch.closed?
    end

    it 'responds appropriately when successful' do
      delete sample_batch_close_url(@sample_batch)

      assert_nil flash[:alert]
      assert_not_nil flash[:notice]
      assert_redirected_to survey_queries_url(@sample_batch.survey)
    end

    it 'responds appropriately after failure' do
      SampleBatch.any_instance.stubs(:open).returns(false)

      delete sample_batch_close_url(@sample_batch)

      assert_not_nil flash[:alert]
      assert_nil flash[:notice]
      assert_redirected_to survey_queries_url(@sample_batch.survey)
    end
  end
end
