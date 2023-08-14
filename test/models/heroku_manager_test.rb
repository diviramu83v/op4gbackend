# frozen_string_literal: true

require 'test_helper'

class HerokuManagerTest < ActiveSupport::TestCase
  subject { HerokuManager.new }

  describe 'methods' do
    it 'responds ' do
      assert_respond_to subject, :worker_count
      assert_respond_to subject, :scale_workers
    end
  end

  describe 'mocked API' do
    setup do
      @mock_formation = mock('formation')
      @mock_platform_api = mock('platform_api')

      PlatformAPI.expects(:connect_oauth).returns(@mock_platform_api).once
      @mock_platform_api.expects(:formation).returns(@mock_formation).once
    end

    describe '#worker_count' do
      it 'returns the number of workers' do
        mock_process_list = [{ 'quantity' => 2, 'type' => 'worker', 'command' => 'sidekiq' }]
        @mock_formation.expects(:list).returns(mock_process_list).once

        assert_equal 2, subject.worker_count
      end

      it 'silently handles Excon::Error::Timeout errors' do
        @mock_list = mock('worker_list')

        @mock_formation.expects(:list).returns(@mock_list).once
        @mock_list.expects(:find).raises(Excon::Error::Timeout)

        assert_nil subject.worker_count
      end
    end

    describe '#scale_workers' do
      it 'updates the worker count to the provided number and returns the worker count' do
        mock_result = { 'quantity' => 5 }
        @mock_formation.expects(:update)
                       .with('op4g-staging', 'worker', quantity: 5)
                       .returns(mock_result)
                       .once

        subject.scale_workers(worker_count: 5)
      end
    end
  end
end
