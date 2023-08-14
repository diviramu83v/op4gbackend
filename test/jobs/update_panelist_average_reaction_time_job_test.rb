# frozen_string_literal: true

require 'test_helper'

class UpdatePanelistAverageReactionTimeJobTest < ActiveJob::TestCase
  setup do
    @panelist = panelists(:active)
  end

  test 'enqueued properly' do
    assert_no_enqueued_jobs
    assert_enqueued_with(job: UpdatePanelistAverageReactionTimeJob) do
      UpdatePanelistAverageReactionTimeJob.perform_later
    end
    assert_enqueued_jobs 1
  end

  test 'updates average_reaction_time when avg_reaction_time is numeric' do
    Panelist.any_instance.stubs(:avg_reaction_time).returns(150)
    UpdatePanelistAverageReactionTimeJob.perform_now
    @panelist.reload
    assert_equal @panelist.average_reaction_time, @panelist.avg_reaction_time
    assert_equal @panelist.average_reaction_time, 150
  end

  test 'updates average_reaction_time when avg_reaction_time is not numeric' do
    Panelist.any_instance.stubs(:avg_reaction_time).returns('N/A')
    UpdatePanelistAverageReactionTimeJob.perform_now
    @panelist.reload
    assert_nil @panelist.average_reaction_time
  end
end
