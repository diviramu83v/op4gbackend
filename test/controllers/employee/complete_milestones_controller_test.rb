# frozen_string_literal: true

require 'test_helper'

class Employee::CompleteMilestonesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in employees(:operations)
    @survey = surveys(:standard)
  end

  describe '#index' do
    it 'should load the index page' do
      get survey_complete_milestones_url(@survey)

      assert_response :ok
    end
  end

  describe '#create' do
    it 'adds a milestone for the survey' do
      assert_difference -> { CompleteMilestone.count } do
        post "#{survey_complete_milestones_url(@survey)}.js", params: { complete_milestone: { target_completes: 40 } }
      end
    end

    it 'deactivates the previous milestone' do
      post "#{survey_complete_milestones_url(@survey)}.js", params: { complete_milestone: { target_completes: 40 } }
      post "#{survey_complete_milestones_url(@survey)}.js", params: { complete_milestone: { target_completes: 50 } }

      assert_equal @survey.complete_milestones.active.count, 1
    end

    it 'fails if the target is lower than the current completes' do
      Survey.any_instance.stubs(:adjusted_complete_count).returns(50)
      assert_no_difference -> { CompleteMilestone.count } do
        post "#{survey_complete_milestones_url(@survey)}.js", params: { complete_milestone: { target_completes: 40 } }
      end
    end
  end
end
