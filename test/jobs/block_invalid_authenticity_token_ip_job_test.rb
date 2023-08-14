# frozen_string_literal: true

require 'test_helper'

class BlockInvalidAuthenticityTokenIpJobTest < ActiveJob::TestCase
  setup do
    @ip = ip_addresses(:standard)
  end

  it 'is enqueued properly' do
    assert_no_enqueued_jobs

    assert_enqueued_with(job: BlockInvalidAuthenticityTokenIpJob) do
      BlockInvalidAuthenticityTokenIpJob.perform_later(@ip)
    end

    assert_enqueued_jobs 1
  end

  it 'calls the right method' do
    10.times do
      IpEvent.create!(message: 'InvalidAuthenticityToken', created_at: Time.now.utc, ip_address_id: @ip.id)
    end

    @ip.expects(:auto_block).once

    BlockInvalidAuthenticityTokenIpJob.perform_now(@ip)
  end

  it 'ignores the issue until a certain number of errors' do
    9.times do
      IpEvent.create!(message: 'InvalidAuthenticityToken', created_at: Time.now.utc, ip_address_id: @ip.id)
    end

    @ip.expects(:auto_block).never

    BlockInvalidAuthenticityTokenIpJob.perform_now(@ip)
  end
end
