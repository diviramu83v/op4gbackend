# frozen_string_literal: true

require 'test_helper'

class ProjectInvitationTest < ActiveSupport::TestCase
  describe 'fixture' do
    setup do
      @invitation = project_invitations(:standard)
    end

    it 'is valid' do
      @invitation.valid?
      assert_empty @invitation.errors
    end

    test 'default status' do
      assert_equal 'initialized', @invitation.status
    end
  end

  describe '#status' do
    setup do
      @invitation = project_invitations(:standard)
    end

    describe '#initialized!' do
      test 'restricted methods' do
        methods = [:initialized!, :declined!, :clicked!, :finished!, :rejected!, :paid!]
        methods.each do |method|
          assert_raise(SurveyInvitationStatusError) do
            @invitation.send(method)
          end
          assert_equal 'initialized', @invitation.status
        end
      end
    end

    describe '#sent!' do
      it 'sets the status' do
        @invitation.sent!
        assert_equal 'sent', @invitation.status
      end

      it 'records a timestamp' do
        assert_nil @invitation.sent_at
        @invitation.sent!
        assert_not_nil @invitation.sent_at
      end

      test 'restricted methods' do
        @invitation.sent!
        methods = [:initialized!, :sent!, :finished!, :rejected!, :paid!]
        methods.each do |method|
          assert_raise(SurveyInvitationStatusError) do
            @invitation.send(method)
          end
          assert_equal 'sent', @invitation.status
        end
      end

      describe '#declined!' do
        setup do
          @invitation.sent!
        end

        it 'sets the status' do
          @invitation.declined!
          assert_equal 'declined', @invitation.status
        end

        it 'records a timestamp' do
          assert_nil @invitation.declined_at
          @invitation.declined!
          assert_not_nil @invitation.declined_at
        end

        test 'ignored methods' do
          @invitation.declined!
          assert_nothing_raised do
            @invitation.declined!
          end
          assert_equal 'declined', @invitation.status
        end

        test 'restricted methods' do
          @invitation.declined!
          methods = [:initialized!, :sent!, :clicked!, :finished!, :rejected!, :paid!]
          methods.each do |method|
            assert_raise(SurveyInvitationStatusError) do
              @invitation.send(method)
            end
            assert_equal 'declined', @invitation.status
          end
        end
      end

      describe '#clicked!' do
        setup do
          @invitation.sent!
        end

        it 'sets the status' do
          @invitation.clicked!
          assert_equal 'clicked', @invitation.status
        end

        it 'records a timestamp' do
          assert_nil @invitation.clicked_at
          @invitation.clicked!
          assert_not_nil @invitation.clicked_at
        end

        test 'restricted methods' do
          @invitation.clicked!
          # TODO: add this back in: :clicked!,
          methods = [:initialized!, :sent!, :declined!, :rejected!, :paid!]
          methods.each do |method|
            assert_raise(SurveyInvitationStatusError) do
              @invitation.send(method)
            end
            assert_equal 'clicked', @invitation.status
          end
        end

        describe '#finished!' do
          setup do
            @invitation.clicked!
          end

          it 'sets the status' do
            @invitation.finished!
            assert_equal 'finished', @invitation.status
          end

          it 'records a timestamp' do
            assert_nil @invitation.finished_at
            @invitation.finished!
            assert_not_nil @invitation.finished_at
          end

          test 'restricted methods' do
            @invitation.finished!
            methods = [:initialized!, :sent!, :declined!, :clicked!]
            methods.each do |method|
              assert_raise(SurveyInvitationStatusError) do
                @invitation.send(method)
              end
              assert_equal 'finished', @invitation.status
            end
          end

          describe '#rejected!' do
            setup do
              @invitation.finished!
            end

            it 'sets the status' do
              @invitation.rejected!
              assert_equal 'rejected', @invitation.status
            end

            it 'records a timestamp' do
              assert_nil @invitation.rejected_at
              @invitation.rejected!
              assert_not_nil @invitation.rejected_at
            end

            test 'restricted methods' do
              @invitation.rejected!
              methods = [:initialized!, :sent!, :declined!, :clicked!, :finished!, :rejected!, :paid!]
              methods.each do |method|
                assert_raise(SurveyInvitationStatusError) do
                  @invitation.send(method)
                end
                assert_equal 'rejected', @invitation.status
              end
            end
          end

          describe '#paid!' do
            setup do
              @invitation.finished!
            end

            it 'sets the status' do
              @invitation.paid!
              assert_equal 'paid', @invitation.status
            end

            it 'records a timestamp' do
              assert_nil @invitation.paid_at
              @invitation.paid!
              assert_not_nil @invitation.paid_at
            end

            test 'restricted methods' do
              @invitation.paid!
              methods = [:initialized!, :sent!, :declined!, :clicked!, :finished!, :rejected!, :paid!]
              methods.each do |method|
                assert_raise(SurveyInvitationStatusError) do
                  @invitation.send(method)
                end
                assert_equal 'paid', @invitation.status
              end
            end
          end
        end
      end
    end
  end

  describe 'scopes' do
    describe '.unclicked' do
      it 'includes invitations appropriately' do
        ProjectInvitation.delete_all
        assert_difference -> { ProjectInvitation.unclicked.count } do
          @invitation = ProjectInvitation.create(project: projects(:standard), batch: sample_batches(:standard), panelist: panelists(:standard),
                                                 token: SecureRandom.hex, survey: surveys(:standard))
        end
        assert_nil @invitation.clicked_at
        assert_includes ProjectInvitation.unclicked, @invitation
      end
    end

    describe '.clicked' do
      it 'includes invitations appropriately' do
        @invitation = project_invitations(:standard)
        @invitation.sent!

        assert_difference -> { ProjectInvitation.clicked.count } do
          @invitation.clicked!
        end
        assert_not_nil @invitation.clicked_at
        assert_includes ProjectInvitation.clicked, @invitation
      end
    end

    describe '.unfinished' do
      it 'includes invitations appropriately' do
        ProjectInvitation.delete_all
        assert_difference -> { ProjectInvitation.unfinished.count } do
          @invitation = ProjectInvitation.create(project: projects(:standard), batch: sample_batches(:standard), panelist: panelists(:standard),
                                                 token: SecureRandom.hex, survey: surveys(:standard))
        end
        assert_nil @invitation.finished_at
        assert_includes ProjectInvitation.unfinished, @invitation
      end
    end

    describe '.finished' do
      it 'includes invitations appropriately' do
        @invitation = project_invitations(:standard)
        @invitation.sent!
        @invitation.clicked!

        assert_difference -> { ProjectInvitation.finished.count } do
          @invitation.finished!
        end
        assert_not_nil @invitation.finished_at
        assert_includes ProjectInvitation.finished, @invitation
      end
    end

    describe '.undeclined' do
      setup do
        @survey = surveys(:standard)
        @survey.update!(finished_at: 32.days.ago)
      end
      it 'includes invitations appropriately' do
        ProjectInvitation.delete_all
        assert_difference -> { ProjectInvitation.undeclined.count } do
          @invitation = ProjectInvitation.create(project: projects(:standard), batch: sample_batches(:standard), panelist: panelists(:standard),
                                                 token: SecureRandom.hex, survey: @survey)
        end
        assert_nil @invitation.declined_at
        assert_includes ProjectInvitation.undeclined, @invitation
      end
    end

    describe '.declined' do
      it 'includes invitations appropriately' do
        @invitation = project_invitations(:standard)

        assert_difference -> { ProjectInvitation.declined.count } do
          @invitation.sent!
          @invitation.declined!
        end
        assert_not_nil @invitation.declined_at
        assert_includes ProjectInvitation.declined, @invitation
      end
    end

    describe '.rejected' do
      it 'returns invitations with a status of "rejected"' do
        @invitation = project_invitations(:standard)

        assert_difference -> { ProjectInvitation.rejected.count }, 1 do
          @invitation.sent!
          @invitation.clicked!
          @invitation.finished!
          @invitation.rejected!
        end

        assert_not_nil @invitation.rejected_at
        assert_includes ProjectInvitation.rejected, @invitation
      end
    end

    describe '.in_review' do
      it 'returns invitations with a status of "in_review"' do
        @invitation = project_invitations(:standard)

        assert_difference -> { ProjectInvitation.in_review.count }, 1 do
          @invitation.sent!
          @invitation.clicked!
          @invitation.finished!
        end

        assert_not_nil @invitation.finished_at
        assert_nil @invitation.paid_at
        assert_nil @invitation.rejected_at
        assert_includes ProjectInvitation.finished, @invitation
      end
    end

    describe '.invalid_subscription' do
      setup do
        @panelist = panelists(:standard)
        @invitation = project_invitations(:standard)
      end

      it 'returns false' do
        assert_equal false, @invitation.invalid_unsubscription?(@panelist.email)
      end

      it 'returns true' do
        assert_equal true, @invitation.invalid_unsubscription?('test@notvalid.com')
      end
    end

    describe '.unsent' do
      it 'includes invitations appropriately' do
        ProjectInvitation.delete_all

        assert_difference -> { ProjectInvitation.unsent.count } do
          @invitation = ProjectInvitation.create(project: projects(:standard), batch: sample_batches(:standard), panelist: panelists(:standard),
                                                 token: SecureRandom.hex, survey: surveys(:standard))
        end
        assert_nil @invitation.sent_at
        assert_includes ProjectInvitation.unsent, @invitation
      end
    end

    describe '.sent' do
      it 'includes invitations appropriately' do
        @invitation = project_invitations(:standard)

        assert_difference -> { ProjectInvitation.sent.count } do
          @invitation.sent!
        end
        assert_not_nil @invitation.sent_at
        assert_includes ProjectInvitation.sent, @invitation
      end
    end

    describe '.batch_open' do
      it 'includes invitations appropriately' do
        @invitation = project_invitations(:standard)
        assert_nil @invitation.batch.closed_at
        assert_includes ProjectInvitation.batch_open, @invitation

        assert_difference -> { ProjectInvitation.batch_open.count }, -1 do
          @invitation.batch.close
        end
      end
    end

    describe '.project_live' do
      setup do
        stub_disqo_project_and_quota_status_change
        SchlesingerApi.any_instance.stubs(:change_survey_status).returns(nil)
      end

      it 'includes invitations appropriately' do
        @survey = surveys(:standard)
        @invitation = project_invitations(:standard)
        @invitation.update!(project: @survey.project, survey: @survey)

        assert @invitation.survey.live?
        assert_includes ProjectInvitation.project_live, @invitation

        assert_difference -> { ProjectInvitation.project_live.count }, -1 do
          @invitation.project.assign_status('finished')
          @invitation.project.save
        end
      end
    end

    describe '.stale' do
      setup do
        stub_disqo_project_and_quota_status_change
        SchlesingerApi.any_instance.stubs(:change_survey_status).returns(nil)
        @project = projects(:standard)

        travel_to Time.now.utc - 31.days

        @invitation = @project.invitations.first
        @invitation.update!(
          sent_at: nil,
          clicked_at: nil,
          finished_at: nil,
          declined_at: nil,
          reminded_at: nil
        )
        @project.assign_status('finished')
        @project.save!
        assert @project.surveys.all?(&:finished?)

        travel_back
      end

      it 'includes invitations appropriately' do
        assert_difference -> { ProjectInvitation.stale.count }, -1 do
          @invitation.destroy
        end
      end

      it 'requires no sent timestamp' do
        assert_difference -> { ProjectInvitation.stale.count }, -1 do
          @invitation.update!(sent_at: Time.now.utc)
        end
      end

      it 'requires no clicked timestamp' do
        assert_difference -> { ProjectInvitation.stale.count }, -1 do
          @invitation.update!(clicked_at: Time.now.utc)
        end
      end

      it 'requires no finished timestamp' do
        assert_difference -> { ProjectInvitation.stale.count }, -1 do
          @invitation.update!(finished_at: Time.now.utc)
        end
      end

      it 'requires no declined timestamp' do
        assert_difference -> { ProjectInvitation.stale.count }, -1 do
          @invitation.update!(declined_at: Time.now.utc)
        end
      end

      it 'requires no reminded timestamp' do
        assert_difference -> { ProjectInvitation.stale.count }, -1 do
          @invitation.update!(reminded_at: Time.now.utc)
        end
      end

      it 'does not apply to recently finished projects' do
        @project.surveys.each do |survey|
          survey.update!(finished_at: Time.now.utc - 40.days, updated_at: Time.now.utc - 40.days)
        end
        assert_difference -> { ProjectInvitation.stale.count }, -1 do
          @project.surveys.first.update!(finished_at: Time.now.utc - 1.day)
        end
      end

      it 'does not apply to recently updated projects' do
        @project.surveys.each do |survey|
          survey.update!(finished_at: Time.now.utc - 40.days, updated_at: Time.now.utc - 40.days)
        end
        assert_difference -> { ProjectInvitation.stale.count }, -1 do
          @project.surveys.first.update!(updated_at: Time.now.utc - 1.day)
        end
      end

      it 'does not apply to unfinished projects' do
        assert_difference -> { ProjectInvitation.stale.count }, -1 do
          @project.assign_status('live')
          @project.save!
          assert @project.surveys.all?(&:live?)
        end
      end
    end
  end

  describe '#update_payment_status!' do
    it 'marks a ProjectInvitation as paid if a matching Earning is found' do
      @batch = sample_batches(:standard)
      @onboarding = onboardings(:standard)
      @panelist = panelists(:active)

      @invitation = project_invitations(:standard)
      @invitation.update!(batch: @batch, panelist: @panelist, onboarding: @onboarding, status: 'finished')

      @earning = earnings(:one)
      @earning.update!(sample_batch: @batch, panelist: @panelist, onboarding: @onboarding)

      @invitation.update_payment_status!

      assert_equal true, @invitation.status == 'paid'
    end

    it 'marks a ProjectInvitation as rejected if no matching Earning is found' do
      @batch = sample_batches(:standard)
      @panelist = panelists(:active)
      @invitation = project_invitations(:standard)
      @onboarding = onboardings(:standard)
      @onboarding.update!(project_invitation: @invitation)
      @invitation.update!(panelist: @panelist, status: 'finished')

      Earning.where(onboarding: @onboarding).delete_all

      @invitation.update_payment_status!

      assert_equal true, @invitation.status == 'rejected'
    end

    it 'throws an error if no onboarding is present' do
      @batch = sample_batches(:standard)
      @panelist = panelists(:active)
      @invitation = project_invitations(:standard)
      @invitation.update!(panelist: @panelist, status: 'finished')

      assert_raises(RuntimeError) do
        @invitation.update_payment_status!
      end
    end
  end

  describe '#delete_stale_records' do
    setup do
      stub_disqo_project_and_quota_status_change
      SchlesingerApi.any_instance.stubs(:change_survey_status).returns(nil)
      @project = projects(:standard)

      travel_to Time.now.utc - 31.days

      @invitation = @project.invitations.first
      @invitation.update!(
        sent_at: nil,
        clicked_at: nil,
        finished_at: nil,
        declined_at: nil,
        reminded_at: nil
      )
      @project.assign_status('finished')

      travel_back
    end

    it 'removes old invitations' do
      assert_difference -> { @project.invitations.count }, -1 do
        ProjectInvitation.delete_stale_records
      end
    end
  end
end
