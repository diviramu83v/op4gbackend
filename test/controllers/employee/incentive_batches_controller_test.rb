# frozen_string_literal: true

require 'test_helper'

class Employee::IncentiveBatchesControllerTest < ActionDispatch::IntegrationTest
  setup do
    load_and_sign_in_admin
  end

  describe '#index' do
    it 'should load the page' do
      IncentiveRecipient.delete_all
      IncentiveBatch.delete_all
      get incentive_batches_url

      assert_response :ok
    end
  end

  describe '#new' do
    it 'should load the page' do
      get new_incentive_batch_url

      assert_response :ok
    end
  end

  describe '#edit' do
    it 'should load the page' do
      get edit_incentive_batch_url(incentive_batches(:standard))

      assert_response :ok
    end
  end

  describe '#create' do
    setup do
      csv_rows = <<~HEREDOC
        "test@testing.com","test","tester"
      HEREDOC
      @file = Tempfile.new('test_data.csv')
      @file.write(csv_rows)
      @file.rewind
    end

    it 'should create batch' do
      params = {
        incentive_batch: {
          csv_data: Rack::Test::UploadedFile.new(@file, 'text/csv'),
          survey_name: 'Test',
          reward: 200.00,
          employee_id: employees(:operations).id
        }
      }
      assert_difference -> { IncentiveBatch.count } do
        post incentive_batches_url, params: params
      end

      assert_enqueued_jobs 1
      assert_enqueued_with(job: CreateIncentiveRecipientsJob)

      assert_redirected_to incentive_batches_url
    end

    it 'should fail to create batch due to missing required field' do
      params = {
        incentive_batch: {
          csv_data: Rack::Test::UploadedFile.new(@file, 'text/csv'),
          employee_id: employees(:operations).id
        }
      }
      post incentive_batches_url, params: params

      assert_template :new
      assert_not_nil flash[:alert]
    end

    it 'should fail to create batch due to missing upload file' do
      params = {
        incentive_batch: {
          reward: 200.00,
          employee_id: employees(:operations).id
        }
      }
      post incentive_batches_url, params: params

      assert_not_nil flash[:alert]
    end
  end

  describe '#update' do
    setup do
      @incentive_batch = incentive_batches(:standard)
    end
    it 'should update batch' do
      put incentive_batch_url(@incentive_batch), params: { incentive_batch: { reward: 150 } }

      @incentive_batch.reload
      assert_equal 150.0, @incentive_batch.reward.to_f
      assert_redirected_to incentive_batches_url
    end

    it 'should not update batch' do
      put incentive_batch_url(@incentive_batch), params: { incentive_batch: { reward: '' } }

      assert_template :edit
    end
  end
end
