# frozen_string_literal: true

# A record of the email that is sent to invite participants to a client sent survey.
class ClientSentSurveyInvitation < ApplicationRecord
  enum status: {
    initialized: 'initialized',
    sent: 'sent',
    clicked: 'clicked'
  }

  has_secure_token
  has_secure_token :unsubscribe_token

  belongs_to :onramp

  has_one :client_sent_unsubscription, dependent: :destroy

  validates :email, presence: true

  after_create :send_survey_invite

  def send_survey_invite
    ClientSentSurveyMailer.email_survey_invite(self).deliver_later
  end
end
