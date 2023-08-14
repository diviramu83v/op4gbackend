# frozen_string_literal: true

require 'test_helper'

class SampleBatchTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  describe 'fixture' do
    it 'is valid' do
      sample_batch = sample_batches(:standard)
      assert sample_batch.valid?
      assert_empty sample_batch.errors
    end
  end

  describe 'factory' do
    it 'is valid' do
      sample_batch = sample_batches(:standard)
      assert sample_batch.valid?
      assert_empty sample_batch.errors
    end
  end

  describe 'associations' do
    subject { sample_batches(:standard) }

    should have_one(:project)
  end

  describe 'methods' do
    subject { sample_batches(:standard) }

    it 'responds to the expected methods' do
      assert subject.respond_to?(:creating_invitations?)
    end
  end

  describe '#create_invitations' do
    setup do
      @batch = sample_batches(:standard)
      demo_query = demo_queries(:standard)
      @batch.update(query: demo_query)
      panelist = panelists(:standard)
      PanelMembership.create(panel: panels(:standard), panelist: panelist)
      panelist.update(
        email: Faker::Internet.email,
        password: 'testing123',
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        country: Country.find_by(slug: demo_query.country.slug),
        original_panel: Panel.find_by(slug: 'op4g-us'),
        primary_panel: Panel.find_by(slug: 'op4g-us'),
        address: Faker::Address.street_name,
        city: Faker::Address.city,
        state: demo_query.demo_query_state_codes.last.code,
        postal_code: demo_query.zip_codes.last.code,
        birthdate: Date.new(Time.now.utc.year - demo_query.ages.last.value, 1, 1),
        age: 35,
        clean_id_data: { data: 'blank' },
        welcomed_at: Faker::Date.backward(days: 365),
        status: Panelist.statuses[:active],
        panels: [@batch.panel],
        onboardings: [demo_query.encoded_uid_onboardings.last]
      )
      DemoQueryProjectInclusion.destroy_all
      demo_query.zip_codes.last.update(dma: demo_query.dmas.last, msa: demo_query.msas.last, pmsa: demo_query.pmsas.last, county: counties(:standard))
    end

    it 'updates the invitations_created_at timestamp' do
      assert_nil @batch.invitations_created_at
      @batch.create_invitations
      assert_not_nil @batch.invitations_created_at
    end

    it 'creates new invitation objects' do
      @batch.invitations.delete_all
      assert_empty @batch.invitations
      @batch.create_invitations
      assert_not_empty @batch.invitations
    end

    it 'updates the count attribute' do
      @batch.create_invitations
      assert_equal @batch.count, @batch.invitations.count
    end
  end

  describe '#create_invitations' do
    setup do
      @sample_batch = sample_batches(:standard)
      @sample_batch.update!(soft_launch_batch: true)
      @panelist = panelists(:active)
      @panelist2 = panelists(:standard)
    end

    it 'sorts panelists to invite by average_reaction_time when soft_launch_batch is true' do
      @panelist.update!(average_reaction_time: 20)
      @panelist2.update!(average_reaction_time: 25)
      @sample_batch.create_invitations
      assert_equal ProjectInvitation.last.panelist, @panelist2
    end

    it 'adds panelists to invite without an average_reaction_time last when soft_launch_batch is true' do
      @panelist.update!(average_reaction_time: 20)
      @panelist2.update!(average_reaction_time: nil)
      @sample_batch.create_invitations
      assert_equal ProjectInvitation.last.panelist, @panelist2
    end
  end

  describe '#send_invitations' do
    setup do
      stub_disqo_project_and_quota_status_change
      survey = surveys(:standard)
      panel = Panel.create(name: 'testing', slug: 'testing')
      demo_query = DemoQuery.create(panel: panel)
      @batch = SampleBatch.create(query: demo_query, survey: survey, count: 10, incentive_cents: 100, email_subject: 'Test')
      invitations = Array.new(3) { project_invitations(:standard) }
      @batch.invitations << invitations
    end

    it 'queues the send batch invitations job when the batch is startable' do
      employee = employees(:operations)

      @batch.survey.live!
      @batch.invitations_created_at = Time.now.utc

      clear_enqueued_jobs
      assert_no_enqueued_jobs

      @batch.send_invitations(employee)

      assert_enqueued_jobs 1
    end

    it "sends the ready invitations when 'send invitations' method is called" do
      employee = employees(:operations)

      mock_mad_mimi = mock('mad_mimi')
      MadMimiMailer.stubs(:instance).returns(mock_mad_mimi)
      mock_mad_mimi.stubs(:allow_real_emails?).returns(true)
      mock_mad_mimi.stubs(:send)
      mock_mad_mimi.stubs(:successful?).returns(true)

      @batch.survey.update!(status: 'live')
      @batch.update!(invitations_created_at: Time.now.utc)

      clear_enqueued_jobs
      assert_no_enqueued_jobs

      assert_equal @batch.invitations.unsent.count, 1
      assert @batch.invitations.has_been_sent.count.zero?

      assert_performed_with(job: SendBatchInvitationsJob) do
        perform_enqueued_jobs do
          @batch.send_invitations(employee)
        end
      end

      assert @batch.invitations.unsent.count.zero?
      assert_equal @batch.invitations.has_been_sent.count, 1

      assert_performed_jobs 2
    end

    it "doesn't queue the send batch invitations job when the batch isn't startable" do
      employee = employees(:operations)
      @batch.triggered_at = Time.now.utc

      clear_enqueued_jobs
      assert_no_enqueued_jobs

      perform_enqueued_jobs do
        @batch.send_invitations(employee)
      end

      assert_no_performed_jobs
    end

    it 'deactivates unsent batches survey warning' do
      @survey_warning = survey_warnings(:one)
      @survey_warning.update(sample_batch: @batch)
      @batch.stubs(:startable?).returns(true)

      mock_mad_mimi = mock('mad_mimi')
      MadMimiMailer.stubs(:instance).returns(mock_mad_mimi)
      mock_mad_mimi.stubs(:allow_real_emails?).returns(true)
      mock_mad_mimi.stubs(:send)
      mock_mad_mimi.stubs(:successful?).returns(true)

      clear_enqueued_jobs
      assert_no_enqueued_jobs

      employee = employees(:operations)
      perform_enqueued_jobs do
        @batch.send_invitations(employee)
      end

      assert_equal @batch.survey_warnings.active.unsent_batches.count, 0
    end
  end

  describe '#startable?' do
    subject { sample_batches(:standard) }

    it 'only returns true when the batch is untriggered,
                          has sendable batches,
                          and created invitations' do
      subject.triggered_at = nil
      assert_not subject.startable?

      subject.survey.live!
      assert_not subject.startable?

      subject.invitations_created_at = Time.now.utc
      assert subject.startable?
    end
  end

  describe '#remindable' do
    subject { sample_batches(:standard) }

    it 'only returns true when the batch is already sent,
                          does not have reminders queued,
                          does not have reminders sent,
                          and one day has passed' do
      subject.sent_at = Time.now.utc
      assert_not subject.remindable?

      subject.reminders_started_at = nil
      assert_not subject.remindable?

      subject.reminders_finished_at = nil
      assert_not subject.remindable?

      subject.sent_at = Time.now.utc - 2.days
      assert subject.remindable?

      subject.reminders_started_at = Time.now.utc
      assert_not subject.remindable?
    end
  end

  describe '#closable' do
    setup do
      stub_disqo_project_and_quota_status_change
      SchlesingerApi.any_instance.stubs(:change_survey_status).returns(nil)
    end

    subject { sample_batches(:standard) }

    it 'only returns true when the batch is sent,
                          the batch is open,
                          and the project is either live or on hold' do
      subject.survey.draft!
      subject.sent_at = Time.now.utc
      assert_not subject.closable?

      subject.closed_at = Time.now.utc
      assert_not subject.closable?

      subject.survey.live!
      assert_not subject.closable?

      subject.closed_at = nil
      assert subject.closable?

      subject.survey.hold!
      assert subject.closable?

      subject.survey.finished!
      assert_not subject.closable?
    end
  end

  describe '#reopenable' do
    setup do
      stub_disqo_project_and_quota_status_change
      SchlesingerApi.any_instance.stubs(:change_survey_status).returns(nil)
    end

    subject { sample_batches(:standard) }

    it 'only returns true when the batch is sent,
                          the batch is closed,
                          and the project is live or on hold' do
      subject.sent_at = Time.now.utc
      assert_not subject.reopenable?

      subject.closed_at = nil
      assert_not subject.reopenable?

      subject.survey.live!
      assert_not subject.reopenable?

      subject.closed_at = Time.now.utc
      assert subject.reopenable?

      subject.survey.hold!
      assert subject.reopenable?

      subject.survey.finished!
      assert_not subject.reopenable?
    end
  end

  describe '#removable' do
    subject { sample_batches(:standard) }

    it 'will return false if any related invitations have a related onboarding' do
      assert subject.removable?

      invitation = project_invitations(:standard)
      invitation.update!(onboarding: onboardings(:standard))
      subject.invitations << invitation

      assert_not subject.removable?
    end
  end

  describe '#clonable' do
    setup do
      @batch = sample_batches(:standard)
    end

    it 'will return true' do
      assert_equal @batch.clonable?, true
    end
  end

  describe '#editable' do
    setup do
      @batch = sample_batches(:standard)
    end

    it 'will return true' do
      assert_equal @batch.editable?, true
    end

    it 'will return false' do
      @batch.update(sent_at: Time.zone.now)
      @batch.save
      assert_equal @batch.editable?, false
    end
  end

  describe '#open' do
    setup do
      @batch = sample_batches(:standard)
    end

    it 'will set closed_at to nil' do
      @batch.update(closed_at: Time.zone.now)
      assert_not_nil @batch.closed_at

      @batch.open
      assert_nil @batch.closed_at
    end
  end

  describe '#create_survey_warning_if_query_is_unfiltered' do
    it 'will create a survey warning' do
      DemoQuery.any_instance.stubs(:filtered?).returns(false)
      SurveyWarning.delete_all
      assert_difference -> { SurveyWarning.count } do
        SampleBatch.create(query: demo_queries(:standard), count: 10, incentive_cents: 100, email_subject: 'Test')
      end
    end

    it 'will not create a survey warning' do
      DemoQuery.any_instance.stubs(:filtered?).returns(true)
      assert_no_difference -> { SurveyWarning.count } do
        SampleBatch.create(query: demo_queries(:standard), count: 10, incentive_cents: 100, email_subject: 'Test')
      end
    end
  end
end
