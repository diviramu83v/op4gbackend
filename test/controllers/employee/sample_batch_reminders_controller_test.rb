# frozen_string_literal: true

require 'test_helper'

class Employee::SampleBatchRemindersControllerTest < ActionDispatch::IntegrationTest
  it 'creates a sample batch reminder job and updates the record accordingly' do
    load_and_sign_in_operations_employee

    @sample_batch = sample_batches(:standard)

    post sample_batch_remind_url(@sample_batch)

    assert_redirected_to survey_queries_url(@sample_batch.survey)
  end
end
