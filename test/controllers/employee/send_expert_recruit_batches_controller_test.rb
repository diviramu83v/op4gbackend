# frozen_string_literal: true

require 'test_helper'

class Employee::SendExpertRecruitBatchesControllerTest < ActionDispatch::IntegrationTest
  describe '#create' do
    setup do
      load_and_sign_in_admin
      @expert_recruit_batch = expert_recruit_batches(:standard)
    end

    it 'should send an expert recruit batch' do
      ExpertRecruitBatch.any_instance.expects(:start_create_expert_recruits_job).once
      assert @expert_recruit_batch.waiting?
      post expert_recruit_batch_sends_url(@expert_recruit_batch)

      @expert_recruit_batch.reload
      assert @expert_recruit_batch.sent?
    end
  end
end
