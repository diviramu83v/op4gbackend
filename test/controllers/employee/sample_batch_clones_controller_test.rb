# frozen_string_literal: true

require 'test_helper'

class Employee::SampleBatchClonesControllerTest < ActionDispatch::IntegrationTest
  describe 'Employee::SampleBatchClonesController' do
    it 'creates a sample batch clone' do
      load_and_sign_in_operations_employee

      @sample_batch = sample_batches(:standard)

      post sample_batch_clone_url(@sample_batch)

      assert_redirected_to survey_queries_url(@sample_batch.survey)
    end

    it 'alerts when a sample batch clone fails' do
      load_and_sign_in_operations_employee

      @sample_batch = sample_batches(:standard)

      SampleBatch.stubs(:create).returns(false)

      post sample_batch_clone_url(@sample_batch)

      assert_redirected_with_warning
      assert_redirected_to survey_queries_url(@sample_batch.survey)
    end
  end
end
