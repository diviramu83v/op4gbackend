# frozen_string_literal: true

require 'test_helper'

class SurveyTest < ActiveSupport::TestCase
  describe 'fixture' do
    it 'is valid' do
      survey = surveys(:standard)
      survey.valid?
      assert_empty survey.errors
    end
  end

  describe 'factories' do
    describe ':survey' do
      it 'is valid' do
        survey = surveys(:standard)
        assert survey.valid?
        assert_empty survey.errors
      end
    end

    describe ':inactive_survey' do
      it 'is valid' do
        survey = surveys(:standard)
        assert survey.valid?
        assert_empty survey.errors
      end
    end
  end

  describe 'mockable methods' do
    subject { surveys(:standard) }

    it 'responds' do
      assert_respond_to subject, :complete_count
    end
  end

  describe '#remaining_completes' do
    setup do
      @survey = surveys(:standard)
      @survey.update!(target: 10)
      Survey.any_instance.stubs(:adjusted_complete_count).returns(5)
    end

    it 'should give you the amount of completes needed to reach target' do
      assert_equal @survey.remaining_completes, 5
    end
  end

  describe '#prescreener_check_failure_summary' do
    setup do
      @survey = surveys(:standard)
      onboarding = @survey.onboardings.find { |o| o.prescreener_questions.present? }
      question = onboarding.prescreener_questions.find_by(body: 'Are you well?')
      question.update!(selected_answers: ['no'], status: 'complete')
    end

    it 'creates a hash of questions and how many times they were failed' do
      assert_equal @survey.prescreener_check_failure_summary, { 'Are you well?' => 1 }
    end
  end

  describe '#delete_old_keys' do
    setup do
      stub_disqo_project_and_quota_status_change
      SchlesingerApi.any_instance.stubs(:change_survey_status).returns(nil)
      @survey = surveys(:standard)
      @survey.assign_status('finished')
      @survey.save!
    end

    test 'within 30 days' do
      ActiveRecord::AssociationRelation.any_instance.expects(:delete_all).never

      travel_to Time.now.utc + 29.days

      @survey.delete_old_keys
    end

    test 'after 30 days' do
      ActiveRecord::AssociationRelation.any_instance.expects(:delete_all).once

      travel_to Time.now.utc + 31.days

      @survey.delete_old_keys
    end
  end

  describe '#active_within_30_days?' do
    setup do
      stub_disqo_project_and_quota_status_change
    end

    test 'live project' do
      @survey = surveys(:standard)

      assert @survey.active_within_30_days?
    end

    test 'draft project' do
      @survey = surveys(:standard)
      @survey.assign_status('draft')
      @survey.save!

      assert @survey.active_within_30_days?
    end

    test 'hold project' do
      SchlesingerApi.any_instance.stubs(:change_survey_status).returns(nil)
      @survey = surveys(:standard)
      @survey.assign_status('hold')
      @survey.save!

      assert @survey.active_within_30_days?
    end

    test 'waiting project' do
      SchlesingerApi.any_instance.stubs(:change_survey_status).returns(nil)
      @survey = surveys(:standard)
      @survey.assign_status('waiting')
      @survey.save!

      assert @survey.active_within_30_days?
    end

    describe 'finished project' do
      before do
        stub_disqo_project_and_quota_status_change
        SchlesingerApi.any_instance.stubs(:change_survey_status).returns(nil)
        @survey = surveys(:standard)
        @survey.assign_status('finished')
        @survey.save!
      end

      test 'within 30 days' do
        travel_to Time.now.utc + 29.days
        assert @survey.active_within_30_days?
      end

      test 'after 30 days' do
        travel_to Time.now.utc + 31.days
        assert_not @survey.active_within_30_days?
      end
    end

    describe 'archived projects' do
      setup do
        @survey = surveys(:standard)
        @survey.assign_status('archived')
        @survey.save!
      end

      test 'within 30 days' do
        travel_to Time.now.utc + 29.days
        assert @survey.active_within_30_days?
      end

      test 'after 30 days' do
        travel_to Time.now.utc + 31.days
        assert_not @survey.active_within_30_days?
      end
    end
  end

  describe '#live_or_on_hold?' do
    setup do
      @survey = surveys(:standard)
      @survey.assign_status('live')
      @survey.save
    end

    it 'returns true' do
      assert_equal true, @survey.live_or_on_hold?
    end
  end

  describe '#language_code' do
    setup do
      @survey = surveys(:standard)
    end

    it 'returns correct code (en)' do
      assert_equal 'en', @survey.language_code
    end

    it 'returns correct code (zh-TW)' do
      @survey.update!(language: 'Chinese')
      assert_equal 'zh-TW', @survey.language_code
    end
  end

  describe '#complete_count_adjusted?' do
    setup do
      @survey = surveys(:standard)
      @survey.adjustments.delete_all
    end

    it 'responds appropriately' do
      assert_not @survey.complete_count_adjusted?

      @survey.adjustments.create!(client_count: 115)
      assert @survey.complete_count_adjusted?
    end
  end

  describe '#adjusted_complete_count' do
    setup do
      @survey = surveys(:standard)
      @survey.adjustments.delete_all
    end

    test 'adjustments' do
      assert @survey.respond_to?(:complete_count)
      @survey.expects(:complete_count).returns(100).times(4)

      @survey.adjustments.create!(client_count: 115)
      assert_equal 115, @survey.adjusted_complete_count

      @survey.adjustments.create!(client_count: 80)
      assert_equal 80, @survey.adjusted_complete_count
    end
  end

  describe '#unaccepted_count' do
    setup do
      @survey = surveys(:standard)
      @onboarding = onboardings(:standard)
    end
    it 'gives a count of 0' do
      assert_equal @survey.unaccepted_count, 0
    end

    it 'gives a count of 1' do
      @onboarding.accepted!
      assert_equal @survey.unaccepted_count, 1
    end

    it 'gives a count of 1' do
      @onboarding.rejected!
      assert_equal @survey.unaccepted_count, 1
    end

    it 'gives a count of 1' do
      @onboarding.fraudulent!
      assert_equal @survey.unaccepted_count, 1
    end
  end

  describe '#needs_missing_batch_warning?' do
    setup do
      @survey = surveys(:standard)
    end

    it 'should return false if the survey already has this warning' do
      @survey_warning = survey_warnings(:one)
      @survey_warning.update(category: 'unsent_batches')
      assert_not @survey.needs_missing_batch_warning?
    end

    it 'should return true if the survey does not have any batches' do
      assert @survey.needs_missing_batch_warning?
    end

    it 'should return true if all the sample batches are unsent' do
      demo_query = demo_queries(:standard)
      batch = sample_batches(:standard)
      batch.update!(query: demo_query)

      assert @survey.needs_missing_batch_warning?
    end
  end

  describe '#send_milestone_emails_and_set_status_to_hold' do
    setup do
      @survey = surveys(:standard)
      stub_disqo_project_and_quota_status_change
    end

    it 'should mark active reached milestones as sent and set status to hold' do
      @survey.live!
      CompleteMilestone.any_instance.stubs(:target_reached?).returns(true)
      SchlesingerApi.any_instance.stubs(:change_survey_status).returns(nil)

      assert_difference -> { @survey.complete_milestones.active.count }, -1 do
        @survey.send_milestone_emails_and_set_status_to_hold
      end

      assert @survey.hold?
    end

    it 'should not mark active reach milestone as sent nor set status to hold if target has not been reached' do
      @survey.live!

      assert_no_difference -> { @survey.complete_milestones.active.count } do
        @survey.send_milestone_emails_and_set_status_to_hold
      end

      assert @survey.live?
    end
  end

  describe '#remaining_id_count' do
    setup do
      @survey = surveys(:standard)
    end

    it 'should calculate the remaining id count' do
      assert_equal @survey.onboardings.complete.count, 1
      assert_equal @survey.onboardings.complete.accepted.count, 0
      assert_equal @survey.onboardings.complete.fraudulent.count, 0
      assert_equal @survey.onboardings.complete.rejected.count, 0
      assert_equal @survey.remaining_id_count, 1
    end
  end

  describe '#invitations_for_panel(panel:)' do
    setup do
      @survey = surveys(:standard)
      @panel = panels(:standard)
      @panelist = panelists(:standard)
    end

    it 'should find the invitations' do
      @sample_batch = sample_batches(:standard)
      assert_equal @panel, @sample_batch.panel

      invitation = project_invitations(:standard)
      assert_equal @panel, invitation.panel

      assert_contains @survey.invitations_for_panel(panel: @panel), invitation
    end
  end

  describe '#add_key' do
    setup do
      @survey = surveys(:standard)
    end

    it 'should create key' do
      @survey.add_key('test')
      assert_contains @survey.keys.last.value, 'test'
    end
  end

  describe '#update_project_started_at' do
    setup do
      @survey = surveys(:standard)
      @survey.assign_status('draft')
      @survey.save!
    end

    it 'should update project started_at when status changes to live' do
      assert @survey.draft?
      assert @survey.project.started_at.blank?

      assert_difference -> { Project.where.not(started_at: nil).count }, +1 do
        @survey.assign_status('live')
        @survey.save!
      end

      assert @survey.project.started_at.present?
      assert_equal @survey.project.started_at, @survey.started_at
    end

    it 'should not update project started_at if the survey is not live' do
      @survey.update!(started_at: 1.day.ago)

      assert @survey.draft?
      assert @survey.started_at.present?
      assert @survey.project.started_at.blank?

      assert_no_difference -> { Project.where.not(started_at: nil).count } do
        @survey.update_project_started_at
      end

      assert_not_equal @survey.project.started_at, @survey.started_at
    end

    it 'should not update project started_at if survey started_at is missing' do
      assert @survey.draft?
      assert @survey.started_at.blank?
      assert @survey.project.started_at.blank?

      assert_no_difference -> { Project.where.not(started_at: nil).count } do
        @survey.live!
      end

      assert @survey.live?
    end

    it 'should update project started_at if the survey started_at is older than existing project started_at' do
      @survey.project.update!(started_at: 1.day.ago)

      assert @survey.draft?
      assert @survey.project.started_at.present?
      assert_not_equal @survey.project.started_at, @survey.started_at

      @survey.assign_status('live')
      @survey.save!
      @survey.update!(started_at: 2.days.ago)

      assert @survey.live?
      assert_equal @survey.project.started_at, @survey.started_at
    end

    it 'should not update project started_at if the survey started_at is newer than existing project started_at' do
      @survey.project.update!(started_at: 2.days.ago)

      assert @survey.draft?
      assert @survey.project.started_at.present?
      assert_not_equal @survey.project.started_at, @survey.started_at

      @survey.assign_status('live')
      @survey.save!
      @survey.update!(started_at: 1.day.ago)

      assert_not_equal @survey.project.started_at, @survey.started_at
    end

    it 'should update project finished_at to nil when status changes to live if project finished_at is present' do
      @survey.project.update!(finished_at: 1.day.ago)

      assert @survey.draft?
      assert_not_nil @survey.project.finished_at

      assert_difference -> { Project.where.not(started_at: nil).count }, +1 do
        @survey.assign_status('live')
        @survey.save!
      end

      assert_nil @survey.project.finished_at
    end
  end

  describe '#update_project_finished_at' do
    setup do
      @survey = surveys(:standard)
    end

    it 'should update project finished_at when status changes to finished' do
      stub_disqo_project_and_quota_status_change
      SchlesingerApi.any_instance.stubs(:change_survey_status).returns(nil)
      # This is to ensure that the project has only 1 survey
      @survey.project.surveys.last.destroy

      assert @survey.live?
      assert @survey.project.finished_at.blank?

      assert_difference -> { Project.where.not(finished_at: nil).count }, +1 do
        @survey.assign_status('finished')
        @survey.save!
      end

      assert_equal @survey.project.finished_at, @survey.finished_at
    end

    it 'should not update project finished_at if the survey is not finished' do
      # This is to ensure that the project has only 1 survey
      @survey.project.surveys.last.destroy
      @survey.update!(finished_at: 1.day.ago)

      assert @survey.live?
      assert @survey.finished_at.present?
      assert @survey.project.finished_at.blank?

      assert_no_difference -> { Project.where.not(finished_at: nil).count } do
        @survey.update_project_finished_at
      end

      assert_not_equal @survey.project.finished_at, @survey.finished_at
    end

    it 'should not update project finished_at if survey finished_at is missing' do
      stub_disqo_project_and_quota_status_change
      SchlesingerApi.any_instance.stubs(:change_survey_status).returns(nil)
      assert @survey.live?
      assert @survey.finished_at.blank?
      assert @survey.project.started_at.blank?

      assert_no_difference -> { Project.where.not(finished_at: nil).count } do
        @survey.finished!
      end

      assert @survey.finished?
    end

    it 'should update project finished_at if the survey finished_at is newer than existing project finished_at' do
      stub_disqo_project_and_quota_status_change
      SchlesingerApi.any_instance.stubs(:change_survey_status).returns(nil)
      # This is to ensure that the project has only 1 survey
      @survey.project.surveys.last.destroy
      @survey.project.update!(finished_at: 2.days.ago)

      assert @survey.live?
      assert @survey.project.finished_at.present?
      assert_not_equal @survey.project.finished_at, @survey.finished_at

      @survey.assign_status('finished')
      @survey.save!

      assert_equal @survey.project.finished_at, @survey.finished_at
    end

    it 'should not update project finished_at if the survey finished_at is older than existing project finished_at' do
      stub_disqo_project_and_quota_status_change
      SchlesingerApi.any_instance.stubs(:change_survey_status).returns(nil)
      # This is to ensure that the project has only 1 survey
      @survey.project.surveys.last.destroy
      @survey.project.update!(finished_at: 1.day.ago)

      assert @survey.live?
      assert @survey.project.finished_at.present?
      assert_not_equal @survey.project.finished_at, @survey.finished_at

      @survey.assign_status('finished')
      @survey.save!
      @survey.update!(finished_at: 2.days.ago)

      assert_not_equal @survey.project.finished_at, @survey.finished_at
    end

    it 'should update project finished_at if the project has any other finished or archived surveys' do
      stub_disqo_project_and_quota_status_change
      SchlesingerApi.any_instance.stubs(:change_survey_status).returns(nil)
      # This is to ensure that the project's last survey is inactive
      @survey.project.surveys.last.finished!

      assert @survey.live?
      assert_not_equal @survey.project.surveys.count, @survey.project.surveys.inactive.count

      @survey.assign_status('finished')
      @survey.save!

      assert @survey.finished?
      assert_equal @survey.project.surveys.count, @survey.project.surveys.inactive.count
      assert_equal @survey.project.finished_at, @survey.finished_at
    end

    it 'should not update project finished_at if the project has any remaining active surveys' do
      stub_disqo_project_and_quota_status_change
      SchlesingerApi.any_instance.stubs(:change_survey_status).returns(nil)
      assert @survey.live?
      assert_equal @survey.project.surveys.count, @survey.project.surveys.active.count
      assert @survey.project.finished_at.blank?

      assert_no_difference -> { Project.where.not(finished_at: nil).count } do
        @survey.assign_status('finished')
        @survey.save!
      end

      assert @survey.finished?
      assert_not_equal @survey.project.surveys.count, @survey.project.surveys.active.count
      assert_not_equal @survey.project.finished_at, @survey.finished_at
    end
  end

  describe '#clone_survey' do
    setup do
      @survey = surveys(:standard)
    end

    it 'should clone the survey' do
      assert_difference -> { Survey.count }, 1 do
        @survey.clone_survey
      end

      assert_equal Survey.last.project, @survey.project
      assert_equal Survey.last.name, "#{@survey.name} - Clone"
      assert_equal Survey.last.base_link, @survey.base_link
      assert_equal Survey.last.category, @survey.category
      assert_equal Survey.last.loi, @survey.loi
      assert_equal Survey.last.cpi_cents, @survey.cpi_cents
      assert_equal Survey.last.audience, @survey.audience
      assert_equal Survey.last.country_id, @survey.country_id
      assert_equal Survey.last.language, @survey.language
      assert_equal Survey.last.prevent_overlapping_invitations, @survey.prevent_overlapping_invitations
    end

    it 'should clone the vendor batches if present' do
      assert @survey.vendor_batches.present?

      assert_difference -> { VendorBatch.count } do
        @survey.clone_survey
      end

      assert_equal Survey.last.vendor_batches.count, @survey.vendor_batches.count
      assert_equal Survey.last.vendor_batches.first.vendor_id, @survey.vendor_batches.first.vendor_id
    end
  end
end
