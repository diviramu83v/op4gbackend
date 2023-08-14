# frozen_string_literal: true

require 'test_helper'

class Employee::ExpertRecruitBatchRemindersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @expert_recruit_batch = expert_recruit_batches(:standard)
  end

  describe '#create' do
    it 'redirects after creating reminder' do
      load_and_sign_in_operations_employee
      post expert_recruit_batch_reminders_url(@expert_recruit_batch)

      assert_redirected_to survey_expert_recruit_batches_url(@expert_recruit_batch.survey)
    end
  end
end
