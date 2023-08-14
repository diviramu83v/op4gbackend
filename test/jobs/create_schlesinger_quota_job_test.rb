# frozen_string_literal: true

require 'test_helper'

class CreateSchlesingerQuotaJobTest < ActiveSupport::TestCase
  setup do
    Sidekiq::Testing.inline!
    @survey = surveys(:standard)
    @schlesinger_quota_params = '{"cpi":"10","loi":"20","soft_launch_completes_wanted":"20","completes_wanted":"200","conversion_rate":"20","industry_id":"1",
                                  "study_type_id":"1","sample_type_id":"1","start_date_time":"2022-11-05","end_date_time":"2022-11-07"}'
    @clean_qualifications_params = '{"age":[21,22],"gender":["58"]}'
    @qualifications_return_body = [{ qualificationId: 59, name: 'Age', text: 'What is your age?', qualificationCategoryId: 5,
                                     qualificationTypeId: 6, answers: %w[21 22] }]
    SchlesingerApi.any_instance.stubs(:create_project).returns(1)
    SchlesingerApi.any_instance.stubs(:create_survey).returns(1)
    SchlesingerApi.any_instance.stubs(:create_qualifications).returns(@qualifications_return_body)
    SchlesingerApi.any_instance.stubs(:create_quota).returns(1)
    SchlesingerApi.any_instance.stubs(:get_survey_status).returns(1)
    SchlesingerApi.any_instance.stubs(:get_survey_name).returns('Test Survey')
  end

  describe 'creating a schlesinger quota' do
    it 'should queue correctly and create a schlesinger quota' do
      assert_difference -> { SchlesingerQuota.count } do
        CreateSchlesingerQuotaJob.perform_async(@survey.id, @schlesinger_quota_params, @clean_qualifications_params)
      end
      assert_equal 'ui', CreateSchlesingerQuotaJob.queue
    end

    it 'calls broadcast_to' do
      CreateSchlesingerQuotaChannel.expects(:broadcast_to).once
      CreateSchlesingerQuotaJob.perform_async(@survey.id, @schlesinger_quota_params, @clean_qualifications_params)
    end
  end
end
