# frozen_string_literal: true

require 'test_helper'

class ExpertRecruitBatchTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper # needed for assert_enqueued_with helper

  describe 'fixture' do
    setup do
      @batch = expert_recruit_batches(:standard)
    end

    it 'is valid' do
      @batch.valid?
      assert_empty @batch.errors
    end
  end

  describe 'methods' do
    describe '#start_create_expert_recruits_job' do
      setup do
        @batch = expert_recruit_batches(:standard)
      end

      it 'enqueues job' do
        @batch.start_create_expert_recruits_job

        assert_enqueued_jobs 1
      end
    end

    describe '#email_list' do
      setup do
        @batch = expert_recruit_batches(:standard)
      end

      it 'asserts emails are in list and not names' do
        assert @batch.email_list.include?('test@test.com')
        assert_not @batch.email_list.include?('test')
      end
    end

    describe '#first_names_and_emails' do
      setup do
        @batch = expert_recruit_batches(:standard)
      end

      it 'asserts emails and names are in the correct order' do
        assert @batch.first_names_and_emails.first[0] == 'test@test.com'
        assert @batch.first_names_and_emails.first[1] == 'test'
      end
    end

    describe '#unsubscribed_email_list' do
      setup do
        @batch = expert_recruit_batches(:standard)
        @batch.update!(csv_data: '{"expert_test@test.com":"test"}')
        @expert_recruit = expert_recruits(:standard)
      end

      it 'asserts no unsubscribed emails' do
        assert_equal @batch.unsubscribed_email_list.count, 0
      end

      it 'adds an unsubscribed email' do
        ExpertRecruitUnsubscription.create(email: 'expert_test@test.com', expert_recruit: @expert_recruit)
        assert_equal @batch.unsubscribed_email_list.count, 1
      end

      it 'does not add an unsubscribed email' do
        @batch.update!(sent_at: 1.week.ago)
        ExpertRecruitUnsubscription.create(email: 'expert_test@test.com', expert_recruit: @expert_recruit)
        assert_equal @batch.unsubscribed_email_list.count, 0
      end
    end

    describe '#reminders_queued?' do
      setup do
        @batch = expert_recruit_batches(:standard)
      end

      it 'returns false' do
        assert_equal false, @batch.reminders_queued?
      end
    end

    describe '#reminders_sent?' do
      setup do
        @batch = expert_recruit_batches(:standard)
      end

      it 'returns false' do
        assert_equal false, @batch.reminders_sent?
      end
    end

    describe '#one_day_passed?' do
      setup do
        @batch = expert_recruit_batches(:standard)
      end

      it 'returns false' do
        @batch.update!(sent_at: Time.now.utc)
        assert_equal false, @batch.one_day_passed?
      end

      it 'returns true' do
        @batch.update!(sent_at: 2.days.ago)
        assert_equal true, @batch.one_day_passed?
      end
    end

    describe '#view_friendly_csv_data' do
      setup do
        @batch = expert_recruit_batches(:standard)
      end

      it 'formats the csv_data' do
        assert_not_equal 'test@test.com, test', @batch.csv_data
        assert_equal 'test@test.com, test', @batch.view_friendly_csv_data
      end
    end
  end
end
