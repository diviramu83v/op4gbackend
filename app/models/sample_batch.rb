# frozen_string_literal: true

# A sample batch is a group of our panelists who are invited to a survey.
class SampleBatch < ApplicationRecord
  after_create_commit :create_invitation_job

  belongs_to :query, class_name: 'DemoQuery', foreign_key: :demo_query_id, inverse_of: :sample_batches

  has_one :panel, through: :query, inverse_of: :sample_batches
  has_one :survey, through: :query
  has_one :project, through: :survey, inverse_of: :sample_batches

  has_many :invitations, dependent: :delete_all, inverse_of: :batch, class_name: 'ProjectInvitation'
  has_many :earnings, dependent: :restrict_with_exception
  has_many :survey_warnings, dependent: :destroy

  validates :count, :incentive_cents, :email_subject, presence: true
  validates :incentive, numericality: { greater_than: 0 }

  after_create :check_for_warnings

  scope :open_batch, -> { where(closed_at: nil) }
  scope :unsent, -> { where(sent_at: nil) }
  scope :by_first_created, -> { order('created_at') }
  scope :most_recent_first, -> { order('created_at DESC') }

  delegate :invitable_panelist_ids, to: :query

  monetize :incentive_cents, allow_nil: true

  def onramp
    survey.onramp_for_panel(panel)
  end

  def create_invitations
    # Prevent invitation creation job from running more than once.
    return if creating_invitations? || invitations_created?

    record_invitation_creation_start
    invite_selected_panelists
    record_invitation_creation_finish
    record_new_invitation_count
  end

  def creating_invitations?
    invitations_started_at.present? && invitations_created_at.nil?
  end

  def send_invitations(current_employee)
    return unless startable?

    update!(triggered_at: Time.now.utc)
    survey_warnings.unsent_batches.find_each(&:mark_as_inactive)

    SendBatchInvitationsJob.perform_later(self, current_employee)
  end

  def send_reminders(current_employee)
    remindable_invitations.find_each do |invitation|
      next if invitation.reminded?

      ReminderDeliveryJob.perform_later(invitation, current_employee)
    end
  end

  def invitation_count
    invitations.size
  end

  def invitation_sent_count
    invitations.has_been_sent.size
  end

  def invitation_clicked_count
    invitations.has_been_clicked.size
  end

  def invitation_completed_count
    invitations.complete.count
  end

  def editable?
    unsent?
  end

  def clonable?
    project.active?
  end

  def startable?
    untriggered? && survey.live? && invitations_created?
  end

  def open?
    closed_at.nil?
  end

  def closed?
    !open?
  end

  def closable?
    sent? && open? && survey.live_or_on_hold?
  end

  def reopenable?
    sent? && closed? && survey.live_or_on_hold?
  end

  def removable?
    invitations.onboarded.none? && unsent?
  end

  def remindable_invitations
    invitations.open_invitation.unreminded.unclicked
  end

  def reminders_queued?
    reminders_started_at.present? && (Time.now.utc - reminders_started_at < 1.day)
  end

  def reminders_sent?
    reminders_finished_at.present? && (Time.now.utc - reminders_finished_at < 1.day)
  end

  def remindable?
    sent? && !reminders_queued? && !reminders_sent? && one_day_passed?
  end

  def one_day_passed?
    Time.now.utc - sent_at > 1.day
  end

  def sent?
    sent_at.present?
  end

  def unsent?
    !sent?
  end

  def triggered?
    triggered_at.present?
  end

  def untriggered?
    !triggered?
  end

  def clonable_fields
    {
      demo_query_id: demo_query_id,
      incentive_cents: incentive_cents,
      count: count,
      email_subject: email_subject,
      label: label,
      description: description
    }
  end

  def close
    update!(closed_at: Time.now.utc)
  end

  def open
    update!(closed_at: nil)
  end

  # TODO: Move this to private section. It's only exposed for testing purposes. :-(
  def create_invitation(panelist_id)
    invitations << ProjectInvitation.new(
      project: project,
      survey: survey,
      panelist_id: panelist_id,
      group: panelist_group(panelist_id)
    )
  end

  private

  def record_invitation_creation_start
    update!(invitations_started_at: Time.now.utc)
  end

  def invite_selected_panelists
    return if count.zero?

    panelist_ids = soft_launch_batch == true ? sort_ids_by_reaction_time(invitable_panelist_ids) : invitable_panelist_ids

    # Invitable panelist ids is an array at the moment. Index is 0-based, so
    # targeting count - 1 panelists.
    selected_panelist_ids = panelist_ids[0..(count - 1)]

    selected_panelist_ids.in_groups_of(1000, false) do |panelist_id_group|
      panelist_id_group.each do |panelist_id|
        create_invitation(panelist_id)
      rescue ActiveRecord::RecordNotUnique
        next
      end
    end
  end

  # rubocop:disable Metrics/MethodLength
  def sort_ids_by_reaction_time(ids)
    panelists_and_reaction_time = {}
    panelists_without_reaction_time = []
    ids.each do |id|
      panelist = Panelist.find_by(id: id)

      if panelist.average_reaction_time.nil?
        panelists_without_reaction_time << panelist.id
      else
        panelists_and_reaction_time[id] = panelist.average_reaction_time
      end
    end

    sorted_hash = panelists_and_reaction_time.sort_by { |_k, v| v }.to_h
    sorted_ids = sorted_hash.keys
    sorted_ids.push(*panelists_without_reaction_time)
  end
  # rubocop:enable Metrics/MethodLength

  def panelist_group(panelist_id)
    panelist = Panelist.find(panelist_id)
    return 1 if panelist.created_at > 30.days.ago
    return 5 if panelist.score_percentile.blank?

    percentile_group(panelist.score_percentile)
  end

  def percentile_group(score)
    percentile_range_groups.select do |_key, arr|
      score.between?(arr.first, arr.last)
    end.keys.first&.to_s&.to_i
  end

  def percentile_range_groups
    {
      '2': [75, 100],
      '3': [50, 74],
      '4': [25, 49],
      '5': [0, 24]
    }
  end

  def record_invitation_creation_finish
    update!(invitations_created_at: Time.now.utc)
  end

  def record_new_invitation_count
    update count: invitations.size
  end

  def invitations_created?
    invitations_created_at.present?
  end

  def create_invitation_job
    return if survey.blank?

    InvitationCreationJob.perform_later(self)
  end

  def check_for_warnings
    SurveyWarning.check_batch(self)
  end
end
