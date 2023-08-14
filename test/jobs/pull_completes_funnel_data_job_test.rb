# frozen_string_literal: true

require 'test_helper'

class PullCompletesFunnelDataJobTest < ActiveJob::TestCase
  it 'produces the recruitment source report' do
    panel = panels(:standard)
    CompletesFunnelChannel.expects(:broadcast_to).once
    PullCompletesFunnelDataJob.perform_now(panel, nil, nil)
  end
end
