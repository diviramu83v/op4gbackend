# frozen_string_literal: true

require 'test_helper'

class CreateExpertRecruitsJobTest < ActiveJob::TestCase
  setup do
    @batch = expert_recruit_batches(:standard)
    @email_list = ['test@test.com', 'test1@test.com']
    @survey = surveys(:standard)
  end

  test 'is enqueued' do
    assert_no_enqueued_jobs

    assert_enqueued_with(job: CreateExpertRecruitsJob) do
      CreateExpertRecruitsJob.perform_later(@batch, @survey)
    end

    assert_enqueued_jobs 1
  end

  test 'does not create recruits' do
    assert_no_difference -> { ExpertRecruit.count } do
      CreateExpertRecruitsJob.perform_later(@email_list, @survey)
    end
  end

  test 'creates recruits' do
    assert_difference -> { ExpertRecruit.count } do
      CreateExpertRecruitsJob.perform_now(@batch, @survey)
    end
  end

  test 'does not create recruits for unsubscribed email addresses' do
    assert_no_difference -> { ExpertRecruit.count } do
      ExpertRecruitUnsubscription.create!(email: 'test@test.com', expert_recruit: expert_recruits(:standard))
      CreateExpertRecruitsJob.perform_now(@batch, @survey)
    end

    assert_no_difference -> { ExpertRecruit.count } do
      @expert_recruit = panelists(:standard)
      Unsubscription.create!(email: 'test@test.com', panelist: @expert_recruit)
      CreateExpertRecruitsJob.perform_now(@batch, @survey)
    end
  end
end
