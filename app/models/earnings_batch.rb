# frozen_string_literal: true

# Tracks a group of IDs that need to be turned into earnings records.
class EarningsBatch < ApplicationRecord
  belongs_to :employee
  belongs_to :survey

  has_many :earnings, dependent: :restrict_with_exception

  validates :amount, :ids, presence: true

  after_create :process_ids

  monetize :amount_cents, allow_nil: true

  def raw_id_count
    ids.split("\r\n").count
  end

  private

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def process_ids
    id_array = ids.split("\r\n")

    id_array.each do |id|
      traffic = survey.onboardings.find_by(uid: id)
      next if traffic.nil?
      next if traffic.earning.present?
      next if traffic.panelist.nil?

      invitation = ProjectInvitation.find_by(token: id)
      next if invitation.nil?

      Earning.create_with(onboarding: traffic, panelist: traffic.panelist, sample_batch: invitation.batch, total_amount: amount)
             .find_or_create_by(panelist: traffic.panelist, sample_batch: invitation.batch)
      traffic.accepted!
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize
end
