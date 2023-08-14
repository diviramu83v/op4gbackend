# frozen_string_literal: true

# A recontact invitation record keeps track of one record that is being decoded.
class RecontactInvitation < ApplicationRecord
  enum status: {
    unsent: 'unsent',
    sending: 'sending',
    sent: 'sent',
    clicked: 'clicked'
  }

  validates :status, presence: true

  belongs_to :recontact_invitation_batch
  belongs_to :original_onboarding, class_name: 'Onboarding', foreign_key: :onboarding_id, inverse_of: :recontact_invitations

  has_one :survey, through: :recontact_invitation_batch, inverse_of: :recontact_invitations
  has_one :recontacted_onboarding, class_name: 'Onboarding', dependent: :restrict_with_exception

  has_secure_token
end
