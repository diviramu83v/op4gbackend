# frozen_string_literal: true

require 'test_helper'

class WorkerScalingJobTest < ActiveJob::TestCase
  it 'tells the worker manager to scale' do
    skip_in_ci
    WorkerManager.any_instance.expects(:scale).once

    WorkerScalingJob.perform_now
  end
end
