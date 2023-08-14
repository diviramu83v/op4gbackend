# frozen_string_literal: true

# A client sent survey contains data used for client sent invitations to a survey
class ClientSentSurvey < ApplicationRecord
  validates :incentive, :description, :email_subject, presence: true

  after_create :add_onramp

  belongs_to :survey
  belongs_to :employee

  monetize :incentive_cents, allow_nil: true

  def onramp_token
    survey.onramps.client_sent.first.token
  end

  private

  def add_onramp
    Onramp.create!(
      category: Onramp.categories[:client_sent],
      survey: survey,
      check_clean_id: false,
      check_recaptcha: false,
      check_gate_survey: false
    )
  end
end
