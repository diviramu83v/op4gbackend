# frozen_string_literal: true

# An expert recruit get invited to a locked panel
class ExpertRecruit < ApplicationRecord
  has_secure_token
  has_secure_token :unsubscribe_token

  validates :email, presence: true

  belongs_to :survey
  belongs_to :expert_recruit_batch, optional: true

  has_one :expert_recruit_unsubscription, dependent: :destroy

  after_create :send_survey_invite

  scope :unclicked, -> { where(clicked_at: nil) }

  def send_survey_invite
    ExpertMailer.email_survey_invite(self).deliver_later
  end

  def send_survey_invite_reminder
    ExpertMailer.email_survey_invite_reminder(self).deliver_later
  end

  def clicked!
    update!(clicked_at: Time.now.utc)
  end

  def unsubscribed?
    ExpertRecruitUnsubscription.find_by(email: email).present? || Unsubscription.find_by(email: email).present?
  end
end
