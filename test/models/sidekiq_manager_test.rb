# frozen_string_literal: true

require 'test_helper'

class SidekiqManagerTest < ActiveSupport::TestCase
  subject { SidekiqManager.new }

  describe 'public methods' do
    it 'respond' do
      skip_in_ci
      assert_respond_to subject, :job_count
      assert_respond_to subject, :busy_workers?
    end
  end

  describe '#busy_workers?' do
    describe '3 busy threads in 1 worker' do
      setup do
        workers = [{ 'busy' => '3' }, { 'busy' => '0' }]

        Sidekiq::ProcessSet.stubs(:new).returns(workers)
      end

      it 'returns true' do
        skip_in_ci
        assert SidekiqManager.new.busy_workers?
      end
    end

    describe '1 busy threads in 2 workers' do
      setup do
        workers = [{ 'busy' => '1' }, { 'busy' => '1' }]

        Sidekiq::ProcessSet.stubs(:new).returns(workers)
      end

      it 'returns true' do
        skip_in_ci
        assert SidekiqManager.new.busy_workers?
      end
    end

    describe '0 busy threads' do
      setup do
        workers = [{ 'busy' => '0' }, { 'busy' => '0' }]

        Sidekiq::ProcessSet.stubs(:new).returns(workers)
      end

      it 'returns false' do
        skip_in_ci
        assert_not SidekiqManager.new.busy_workers?
      end
    end
  end

  describe '#job_count' do
    describe 'with 3 jobs enqueued and 0 retries' do
      setup do
        Sidekiq::Stats.any_instance.stubs(:enqueued).returns(3)
        Sidekiq::Stats.any_instance.stubs(:retry_size).returns(0)
      end

      it 'returns 3 jobs' do
        skip_in_ci
        assert_equal 3, SidekiqManager.new.job_count
      end
    end

    describe 'with 100 jobs enqueued and 3 retries' do
      setup do
        Sidekiq::Stats.any_instance.stubs(:enqueued).returns(100)
        Sidekiq::Stats.any_instance.stubs(:retry_size).returns(3)
      end

      it 'returns 103 jobs' do
        skip_in_ci
        assert_equal 103, SidekiqManager.new.job_count
      end
    end

    describe 'with 0 jobs enqueued and 0 retries' do
      setup do
        Sidekiq::Stats.any_instance.stubs(:enqueued).returns(0)
        Sidekiq::Stats.any_instance.stubs(:retry_size).returns(0)
      end

      it 'returns 0 jobs' do
        skip_in_ci
        assert_equal 0, SidekiqManager.new.job_count
      end
    end
  end
end
