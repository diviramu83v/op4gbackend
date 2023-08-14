# frozen_string_literal: true

require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  describe 'fixture' do
    setup do
      @project = projects(:standard)
    end

    it 'is valid' do
      assert @project.valid?
      assert_empty @project.errors
    end
  end

  describe 'factories' do
    describe ':project' do
      it 'is valid' do
        project = projects(:standard)
        assert project.valid?
        assert_empty project.errors
      end
    end

    describe ':inactive_project' do
      it 'is valid' do
        project = projects(:standard)
        assert project.valid?
        assert_empty project.errors
      end
    end

    describe ':typical_project' do
      it 'is valid' do
        project = projects(:standard)
        assert project.valid?
        assert_empty project.errors
      end
    end
  end

  describe 'callbacks' do
    describe '#update_invitations_on_finish' do
      test 'call #update_status! on the related invitations when the Project is marked "finished"' do
        stub_disqo_project_and_quota_status_change
        SchlesingerApi.any_instance.stubs(:change_survey_status).returns(nil)
        @project = projects(:standard)
        @project.invitations.each do |invitation|
          invitation.update!(status: :finished)
        end

        ProjectInvitation.any_instance.expects(:update_payment_status!)
        # finish the project and trigger the callback
        @project.assign_status(:finished)
        @project.save!
      end

      test 'doesn\'t call #update_status! when the project is saved but is not marked "finished"' do
        @project = projects(:standard)
        assert_equal true, @project.invitations.count.positive?

        ProjectInvitation.any_instance.expects(:update_payment_status!).never
        # ensure the Project isn't finished
        assert_equal false, @project.finished?

        # trigger the callback
        @project.save!
      end
    end

    test 'mark finished ProjectInvitations as rejected or paid when Project status is changed to "finished' do
      stub_disqo_project_and_quota_status_change
      SchlesingerApi.any_instance.stubs(:change_survey_status).returns(nil)
      @project = projects(:standard)

      @first_invitation = @project.invitations.first

      # add a second invitation to this Project
      @project.invitations << project_invitations(:standard)

      # Create an Onboarding that relates to each ProjectInvitation on this Project
      @project.invitations.each do |i|
        Onboarding.create(onramp: onramps(:testing),
                          uid: SecureRandom.hex,
                          token: SecureRandom.hex,
                          initial_survey_status: 'live',
                          ip_address: ip_addresses(:standard),
                          recaptcha_token: SecureRandom.hex,
                          gate_survey_token: SecureRandom.hex,
                          response_token: SecureRandom.hex,
                          error_token: SecureRandom.hex,
                          onboarding_token: SecureRandom.hex,
                          project_invitation: i)
      end

      # create an Earning for the 'paid' invitation
      @earning = earnings(:one)

      @earning.update!(
        onboarding: @first_invitation.onboarding
      )

      # mark both ProjectInvitations as finished
      @project.invitations.each do |invitation|
        invitation.update!(status: :finished)
      end

      # finish the project and trigger the callback
      @project.assign_status(:finished)
      @project.save!
      @project.reload

      # separate the invitations by status
      @paid_invitations, @rejected_invitations = @project.invitations.partition do |i|
        i.onboarding.earning.present?
      end

      # assert that the invitations have been updated with the appropriate status
      @paid_invitations.each { |i| assert_equal true, i.status == 'paid' }
      @rejected_invitations.each { |i| assert_equal true, i.status == 'rejected' }

      # assert that none of this Project's ProjectInvitations are left in 'finished' status
      assert_equal true, @project.invitations.finished.empty?
    end
  end

  describe '#assign_status' do
    setup do
      @project = projects(:standard)
      stub_disqo_project_and_quota_status_change
      SchlesingerApi.any_instance.stubs(:change_survey_status).returns(nil)
    end

    it 'should change the status of the project' do
      @project.assign_status('finished')

      assert @project.surveys.all?(&:finished?)
    end
  end

  describe '#relevant_id_level' do
    setup do
      @project = projects(:standard)
    end

    it 'defaults to survey level' do
      assert_equal 'survey', @project.relevant_id_level
    end

    it 'can be set to project level' do
      @project.update!(relevant_id_level: 'project')
      assert_equal 'project', @project.relevant_id_level
    end

    it 'can be set to vendor level' do
      @project.update!(relevant_id_level: 'vendor')
      assert_equal 'vendor', @project.relevant_id_level
    end

    it 'can be set back to survey level' do
      @project.update!(relevant_id_level: 'project')
      @project.update!(relevant_id_level: 'survey')
      assert_equal 'survey', @project.relevant_id_level
    end

    it "can't be set to another random value" do
      @project.update(relevant_id_level: 'random')
      assert_not @project.valid?
    end
  end

  describe '#surveys_that_can_be_changed_to_status' do
    setup do
      @project = projects(:standard)
      %w[draft live hold waiting finished archived].each do |status|
        @project.surveys.create(name: "test_#{status}", status: status, category: 'standard')
      end
    end

    it 'should return live surveys and archived surveys for status of draft' do
      assert @project.surveys_that_can_be_changed_to_status(status: 'draft').all? do |survey|
        %w[live archived].include?(survey.status)
      end
    end

    it 'should return live surveys and archived surveys for status of live' do
      assert @project.surveys_that_can_be_changed_to_status(status: 'live').all? do |survey|
        %w[draft hold waiting].include?(survey.status)
      end
    end

    it 'should return live surveys and archived surveys for status of hold' do
      assert @project.surveys_that_can_be_changed_to_status(status: 'hold').all? do |survey|
        %w[live].include?(survey.status)
      end
    end

    it 'should return live surveys and archived surveys for status of waiting' do
      assert @project.surveys_that_can_be_changed_to_status(status: 'waiting').all? do |survey|
        %w[live hold].include?(survey.status)
      end
    end

    it 'should return live surveys and archived surveys for status of finished' do
      assert @project.surveys_that_can_be_changed_to_status(status: 'finished').all? do |survey|
        %w[live hold waiting].include?(survey.status)
      end
    end

    it 'should return live surveys and archived surveys for status of archived' do
      assert @project.surveys_that_can_be_changed_to_status(status: 'archived').all? do |survey|
        %w[finished draft].include?(survey.status)
      end
    end
  end

  describe '#nonstandard_relevant_id_level?' do
    setup do
      @project = projects(:standard)
    end

    it 'responds appropriately' do
      assert_not @project.nonstandard_relevant_id_level?

      @project.update!(relevant_id_level: 'project')
      assert @project.nonstandard_relevant_id_level?

      @project.update!(relevant_id_level: 'vendor')
      assert @project.nonstandard_relevant_id_level?
    end
  end

  describe '#multiple_surveys' do
    setup do
      @project = projects(:standard)
    end
    it 'returns true' do
      assert_equal true, @project.multiple_surveys?
    end
  end

  describe '#editable?' do
    setup do
      @project = projects(:standard)
    end
    it 'returns true' do
      assert_equal true, @project.editable?
    end
  end

  describe '#panelist_count' do
    setup do
      @project = projects(:standard)
    end
    it 'adds a recontact' do
      assert_equal @project.panelists.count, @project.panelist_count
    end
  end

  describe '#unaccepted_count' do
    setup do
      @project = projects(:standard)
      @onboarding = onboardings(:standard)
    end
    it 'gives a count of 0' do
      assert_equal @project.unaccepted_count, 0
    end

    it 'gives a count of 1' do
      @onboarding.accepted!
      assert_equal @project.unaccepted_count, 1
    end

    it 'gives a count of 1' do
      @onboarding.rejected!
      assert_equal @project.unaccepted_count, 1
    end

    it 'gives a count of 1' do
      @onboarding.fraudulent!
      assert_equal @project.unaccepted_count, 1
    end
  end

  describe '#invitation_count' do
    setup do
      @project = projects(:standard)
    end
    it 'adds a recontact' do
      assert_equal @project.invitations.count, @project.invitation_count
    end
  end

  describe '#invitation_send_count' do
    setup do
      @project = projects(:standard)
    end
    it 'adds a recontact' do
      assert_equal @project.invitations.has_been_sent.count, @project.invitation_sent_count
    end
  end

  describe '#add_recontact' do
    setup do
      @project = projects(:standard)
    end
    it 'adds a recontact' do
      assert_difference -> { @project.surveys.recontact.count } do
        @project.add_recontact
      end
    end
  end

  describe '#return_key_surveys?' do
    setup do
      @project = projects(:standard)
    end
    it 'returns true' do
      assert_equal true, @project.return_key_surveys?
    end

    it 'returns false' do
      @project.surveys.each do |survey|
        survey.return_keys.delete_all
      end
      assert_equal false, @project.return_key_surveys?
    end
  end

  describe '#survey_response_suffix' do
    setup do
      @project = projects(:standard)
    end
    it 'returns with key' do
      assert_equal '?key={{key}}&uid=', @project.survey_response_suffix
    end

    it 'returns without key' do
      @project.surveys.each do |survey|
        survey.return_keys.delete_all
      end
      assert_equal '?uid=', @project.survey_response_suffix
    end
  end

  describe '#mark_rejected_ids' do
    setup do
      @project = projects(:standard)
      @onboardings = @project.onboardings
    end
    it 'adds rejected status to complete onboarding only' do
      assert_difference -> { @project.onboardings.rejected.count } do
        @project.mark_rejected_ids
      end
    end

    it 'does not add rejected status to onboardings with existing accepted client_status' do
      previous_count = @project.onboardings.rejected.count
      @project.onboardings.each do |onboarding|
        onboarding.update!(client_status: :accepted)
      end
      @project.mark_rejected_ids

      assert_equal previous_count, @project.onboardings.rejected.count
    end

    it 'does not add rejected status to onboardings with existing fraudulent client_status' do
      previous_count = @project.onboardings.rejected.count
      @project.onboardings.each do |onboarding|
        onboarding.update!(client_status: :fraudulent)
      end
      @project.mark_rejected_ids

      assert_equal previous_count, @project.onboardings.rejected.count
    end

    it 'adds a default rejected reason to ids rejected at close out' do
      assert_difference -> { @onboardings.where(rejected_reason: 'Rejected at project close out').count } do
        @project.mark_rejected_ids
      end
    end

    it 'does not add a default reason to onboardings with existing rejected_reason' do
      complete = @onboardings.complete.first
      complete.update!(client_status: 'rejected', rejected_reason: 'bad')
      @project.mark_rejected_ids
      assert_not_equal complete.rejected_reason, 'Rejected at project close out'
    end
  end

  describe '#needs_closing_out_manager_first' do
    setup do
      @project = Project.first
      @manager = employees(:operations)
      stub_disqo_project_and_quota_status_change
    end

    it 'should return a list of finished projects that need to be closed out' do
      stub_disqo_project_and_quota_status_change
      SchlesingerApi.any_instance.stubs(:change_survey_status).returns(nil)
      @project.assign_status('finished')
      @project.save!

      assert_equal 1, Project.needs_closing_out_manager_first(@manager).count
    end

    it 'should return a list of waiting projects that need to be closed out' do
      SchlesingerApi.any_instance.stubs(:change_survey_status).returns(nil)
      @project.assign_status('waiting')
      @project.save!

      assert_equal 1, Project.needs_closing_out_manager_first(@manager).count
    end
  end

  describe '#create_earnings_for_accepted_panelists' do
    setup do
      @project = projects(:standard)
      @invitation = project_invitations(:standard)
    end

    it 'adds earnings records successfully' do
      Earning.delete_all
      onboarding = onboardings(:complete)
      onboarding.project_invitation = @invitation
      onboarding.onramp = onramps(:panel)
      onboarding.client_status = :accepted
      onboarding.save!

      assert_difference -> { Earning.count } do
        @project.create_earnings_for_accepted_panelists
      end
    end
  end

  describe '#remaining_id_count' do
    setup do
      @project = projects(:standard)
    end

    it 'should calculate the remaining id count' do
      assert_equal @project.onboardings.complete.count, 1
      assert_equal @project.onboardings.complete.accepted.count, 0
      assert_equal @project.onboardings.complete.fraudulent.count, 0
      assert_equal @project.onboardings.complete.rejected.count, 0
      assert_equal @project.remaining_id_count, 1
    end
  end
end
