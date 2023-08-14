# frozen_string_literal: true

require 'test_helper'

class Employee::SampleBatchesControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  setup do
    sign_in employees(:operations)
  end

  it 'view new sample batch page' do
    @query = demo_queries(:standard)

    get new_query_sample_url(@query)

    assert_response :ok
  end

  describe '#edit' do
    setup do
      @sample_batch = sample_batches(:standard)
    end

    it 'should load the edit page' do
      get edit_sample_batch_url(@sample_batch)

      assert_response :ok
    end
  end

  it 'create sample batch' do
    @query = demo_queries(:standard)
    @params = { sample_batch: { count: 105, incentive: 4.5, email_subject: 'Test subject' } }

    assert_not_nil @query.survey
    assert_no_enqueued_jobs

    assert_enqueued_with(job: InvitationCreationJob) do
      assert_difference -> { SampleBatch.count } do
        post query_sample_url(@query), params: @params
      end
    end

    assert_enqueued_jobs 1
    assert_redirected_with_no_warning
  end

  it 'sample batch creation failure' do
    # Force failure.
    SampleBatch.any_instance.stubs(:save).returns(false)

    @query = demo_queries(:standard)
    @params = { sample_batch: { count: 105 } }

    assert_no_difference -> { SampleBatch.count } do
      post query_sample_url(@query), params: @params
    end
  end

  describe '#update' do
    it 'updates a sample batch' do
      @sample_batch = sample_batches(:standard)
      @query = demo_queries(:standard)
      @params = { sample_batch: { count: 105, incentive: 4.5, email_subject: 'Test subject' } }

      assert_not_nil @query.survey

      assert_no_difference -> { SampleBatch.count } do
        patch sample_batch_url(@sample_batch), params: @params
      end

      assert_redirected_with_no_warning
    end

    it 'fails to update a sample batch' do
      SampleBatch.any_instance.stubs(:save).returns(false)
      @sample_batch = sample_batches(:standard)
      @query = demo_queries(:standard)
      @params = { sample_batch: { count: 105, incentive: 4.5, email_subject: 'Test subject' } }

      assert_not_nil @query.survey

      assert_no_difference -> { SampleBatch.count } do
        patch sample_batch_url(@sample_batch), params: @params
      end

      assert_template :edit
    end
  end

  describe 'DELETE /sample_batches/:id' do
    describe 'newly created batch' do
      before do
        @sample_batch = sample_batches(:standard)
        Earning.delete_all
      end

      it 'is deleted' do
        assert_difference -> { SampleBatch.count }, -1 do
          delete sample_batch_url(@sample_batch)
        end
      end
    end

    describe 'batch that is creating invitations' do
      before do
        @sample_batch = sample_batches(:standard)

        SampleBatch.any_instance.expects(:creating_invitations?).returns(true).once
      end

      it 'is not deleted' do
        assert_no_difference -> { SampleBatch.count } do
          delete sample_batch_url(@sample_batch)
        end
      end
    end

    describe 'batch that is not removable' do
      setup do
        @sample_batch = sample_batches(:standard)

        SampleBatch.any_instance.expects(:removable?).returns(false).once
      end

      it 'is not deleted' do
        assert_no_difference -> { SampleBatch.count } do
          delete sample_batch_url(@sample_batch)
        end
      end
    end
  end
end
