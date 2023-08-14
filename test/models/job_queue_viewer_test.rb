# frozen_string_literal: true

require 'test_helper'

class JobQueueViewerTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  describe '#size' do
    it 'returns 0 when no jobs in the queue' do
      Sidekiq::Queue.any_instance.stubs(:size).returns(0)

      queue = JobQueueViewer.new('invitations')

      assert_equal 0, queue.size
    end

    it 'returns the appropriate count when there are jobs in the queue' do
      Sidekiq::Queue.any_instance.stubs(:size).returns(3)

      queue = JobQueueViewer.new('invitations')

      assert_equal 3, queue.size
    end
  end
end
