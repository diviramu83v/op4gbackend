# frozen_string_literal: true

require 'test_helper'

class DeactivateStalePanelistsJobTest < ActiveJob::TestCase
  it 'calls the correct Panelist method' do
    Panelist.expects(:deactivate_stale_panelists).once

    DeactivateStalePanelistsJob.perform_now
  end
end
