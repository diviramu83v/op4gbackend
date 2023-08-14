# frozen_string_literal: true

class SurveyInvitationStatusError < StandardError; end

# An invitation for a panelist to join a survey.
class ProjectInvitation < ApplicationRecord
  # We're overriding some of the auto-generated methods below.
  enum status: {
    initialized: 'initialized',
    sent: 'sent',
    declined: 'declined',
    clicked: 'clicked',
    finished: 'finished',
    rejected: 'rejected',
    paid: 'paid',
    ignored: 'ignored'
  }

  validates :status, presence: true

  belongs_to :project # Enables a DB-enforced unique key on project/panelist.
  belongs_to :survey
  belongs_to :batch, class_name: 'SampleBatch', foreign_key: :sample_batch_id, inverse_of: :invitations
  belongs_to :panelist
  has_one :onboarding, dependent: :restrict_with_exception
  has_one :query, through: :batch
  has_one :panel, through: :query
  has_secure_token

  delegate :incentive, :open?, :closed?, to: :batch

  scope :open_invitation, -> { sent.unfinished.unclicked.undeclined.project_live.batch_open }
  scope :has_been_sent, -> { where.not(sent_at: nil) }
  scope :unsent, -> { where(sent_at: nil) }
  scope :reminded, -> { where.not(reminded_at: nil) }
  scope :unreminded, -> { where(reminded_at: nil) }
  scope :has_been_clicked, -> { where.not(clicked_at: nil) }
  scope :unclicked, -> { where(clicked_at: nil) }
  scope :in_review, -> { finished.where(paid_at: nil, rejected_at: nil) }
  scope :unfinished, -> { where(finished_at: nil) }
  scope :undeclined, -> { where(declined_at: nil) }
  scope :onboarded, -> { joins(:onboarding) }
  scope :stale, -> { unsent.unclicked.unfinished.undeclined.unreminded.survey_finished_for_30_days }
  scope :survey_finished_for_30_days, -> { joins(:survey).merge(Survey.finished_for_30_days) }
  scope :survey_finished_in_past_month, lambda {
    joins(:survey).merge(Survey.finished_in_past_month)
                  .where(status: 'finished')
  }
  scope :project_live, -> { joins(:project).merge(Project.live) }
  scope :batch_open, -> { joins(:batch).merge(SampleBatch.open_batch) }
  scope :complete, -> { joins(:onboarding).merge(Onboarding.complete) }
  scope :terminate, -> { joins(:onboarding).merge(Onboarding.terminate) }
  scope :quotafull, -> { joins(:onboarding).merge(Onboarding.quotafull) }
  scope :most_recently_sent_first, -> { order('sent_at DESC') }
  scope :oldest_first, -> { order(:created_at) }
  scope :most_recently_completed_first, -> { order('finished_at DESC') }
  scope :newest_first, -> { order('created_at DESC') }

  def initialized!
    # Don't want to go back the default status once it's changed.
    raise_status_error(__method__)
  end

  def sent!
    raise_status_error(__method__) unless initialized?
    update!(status: 'sent', sent_at: Time.now.utc)
    panelist.update!(last_invited_at: Time.now.utc)
  end

  def ever_sent?
    sent_at.present?
  end

  def declined!
    return if declined?

    raise_status_error(__method__) unless sent?
    update!(status: 'declined', declined_at: Time.now.utc)
  end

  def clicked!
    return if clicked?

    raise_status_error(__method__) unless sent?
    update!(status: 'clicked', clicked_at: Time.now.utc)
  end

  def finished!
    return if finished?

    raise_status_error(__method__) unless clicked?
    update!(status: 'finished', finished_at: Time.now.utc)
  end

  def rejected!
    raise_status_error(__method__) unless finished?
    update!(status: 'rejected', rejected_at: Time.now.utc)
  end

  def paid!
    raise_status_error(__method__) unless finished?
    update!(status: 'paid', paid_at: Time.now.utc)
  end

  # Intentionally not using the status column for these 'reminded' methods.
  def reminded!
    update reminded_at: Time.now.utc
  end

  def reminded?
    reminded_at.present?
  end

  def update_payment_status!
    raise 'expected onboarding record' if onboarding.nil?

    if onboarding.earning.present?
      paid!
    else
      rejected!
    end
  end

  def invalid_unsubscription?(email)
    panelist.email != email
  end

  def self.invited_and_open?(panelist:, survey:)
    find_by(panelist: panelist, survey: survey).try(:open?)
  end

  def self.delete_stale_records
    deleted_count = ProjectInvitation.stale.delete_all
  end

  private

  def raise_status_error(method)
    raise SurveyInvitationStatusError, "ProjectInvitation##{method} cannot be called on an invitation with a '#{status}' status."
  end
end
