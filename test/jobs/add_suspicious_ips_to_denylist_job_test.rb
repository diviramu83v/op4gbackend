# frozen_string_literal: true

require 'test_helper'

class AddSuspiciousIpsToDenylistJobTest < Minitest::Test
  describe 'enqueueing' do
    it 'is enqueued properly' do
      AddSuspiciousIpsToDenylistJob.perform_async
      assert_equal 'default', AddSuspiciousIpsToDenylistJob.queue
    end
  end
  describe 'testing suspicious ips' do
    before do
      Sidekiq::Testing.inline!
    end
    it 'calls the right method' do
      IpAddress.expects(:block_suspicious_ips).once
      AddSuspiciousIpsToDenylistJob.perform_async
    end
  end
end
