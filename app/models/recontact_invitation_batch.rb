# frozen_string_literal: true

# A recontact invitation record tracks the process of converting a batch of encoded UIDs to email addresses / recontact invitations
class RecontactInvitationBatch < ApplicationRecord
  enum status: {
    initialized: 'initialized',
    decoded: 'decoded',
    sending: 'sending',
    sent: 'sent'
  }

  validates :status, presence: true

  belongs_to :survey, inverse_of: :invitation_batches

  has_many :recontact_invitations, dependent: :destroy

  after_create :process_csv_data

  monetize :incentive_cents, allow_nil: true

  def process_csv_data
    return if decoded?

    data = JSON.parse(csv_data, symbolize_names: true)

    data.each do |uid, url|
      onboarding = Onboarding.find_by(token: uid)
      next unless onboarding
      next unless onboarding.project == survey.project
      next if onboarding.find_email_address.blank?

      create_invitation(uid, url)

      decoded!
    end
  end

  def no_valid_ids?
    recontact_invitations.count.zero?
  end

  def invitation_count
    recontact_invitations.size
  end

  def sendable?
    decoded? && incentive_cents.present? && subject.present? && email_body.present? && survey.loi.present?
  end

  def send_invitations(current_employee)
    sending!

    SendRecontactBatchInvitationsJob.perform_later(self, current_employee)
  end

  def create_invitation(uid, url)
    RecontactInvitation.create!(
      uid: uid,
      url: url,
      recontact_invitation_batch: self,
      original_onboarding: Onboarding.find_by(token: uid)
    )
  end
end
