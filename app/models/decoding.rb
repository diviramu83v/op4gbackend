# frozen_string_literal: true

# A decoding record tracks the process of converting a batch of encoded UIDs
#   to data our project managers can use.
class Decoding < ApplicationRecord
  include SharedDecoders

  belongs_to :employee

  has_many :decoded_uids, as: :decodable, dependent: :destroy
  has_many :projects, through: :decoded_uids
  has_many :vendors, through: :decoded_uids
  has_many :api_vendors, through: :decoded_uids
  has_many :vendor_batches, through: :decoded_uids
  has_many :survey_routers, through: :decoded_uids
  has_many :onboardings, through: :decoded_uids
  has_many :panels, through: :onboardings

  validates :encoded_uids, presence: true

  def testing_traffic_uids
    decoded_uids.matched.testing
  end

  def testing_traffic?
    testing_traffic_uids.any?
  end

  def panel_traffic?
    panel_traffic_uids.any?
  end

  def unique_survey_routers
    survey_routers.select('survey_routers.*').distinct
  end

  def unique_vendors
    vendors.select('vendors.*').distinct.order(:name)
  end

  def only_one_vendor?
    unique_vendors.one?
  end

  def first_vendor
    unique_vendors.first
  end

  def unique_api_vendors
    api_vendors.select('vendors.*').distinct.order(:name)
  end

  def matched_uids_for_disqo
    decoded_uids.matched.for_disqo
  end

  def matched_uids_for_cint
    decoded_uids.matched.for_cint
  end

  def disqo_uid?
    decoded_uids.matched.for_disqo.present?
  end

  def cint_uid?
    decoded_uids.matched.for_cint.present?
  end

  def matched_uids_for_api_vendor(vendor)
    # TODO: Figure out why this isn't working. Chaining the scopes works fine
    #   until the last link in the chain. Possibly a bug in ActiveRecord?
    # decoded_uids.for_batch_vendor(vendor)

    decoded_uids
      .joins('inner join onboardings on decoded_uids.onboarding_id = onboardings.id inner join onramps on onboardings.onramp_id = onramps.id')
      .where(onramps: { api_vendor_id: vendor.id })
  end

  # rubocop:disable Layout/LineLength
  def vendor_counts
    @vendor_counts ||=
      decoded_uids
      .joins('inner join onboardings on decoded_uids.onboarding_id = onboardings.id inner join onramps on onboardings.onramp_id = onramps.id inner join vendor_batches on onramps.vendor_batch_id = vendor_batches.id')
      .group('vendor_id').count
  end
  # rubocop:enable Layout/LineLength

  def api_vendor_counts
    @api_vendor_counts ||=
      decoded_uids
      .joins('inner join onboardings on decoded_uids.onboarding_id = onboardings.id inner join onramps on onboardings.onramp_id = onramps.id')
      .group('api_vendor_id').count
  end

  def matched_uids_for_router(router)
    decoded_uids.for_router(router)
  end

  def combined_panel_decodings
    unique_panels.map { |p| decoded_uids_for_panel(p) }.flatten
  end

  def unique_panels
    panels.select('panels.*').distinct.order(:name)
  end

  def multiple_panels?
    unique_panels.count > 1
  end

  # rubocop:disable Metrics/MethodLength
  def decode_uids
    return if decoded?

    uids = encoded_uids.split(/\n/).map(&:strip).compact_blank
    uid_list = []
    uids.each_with_index do |uid, index|
      new_decoded_uid = DecodedUid.new(
        uid: uid,
        decodable_id: id,
        decodable_type: 'Decoding',
        onboarding: Onboarding.find_by(token: uid),
        entry_number: index + 1
      )
      uid_list << new_decoded_uid
    end
    DecodedUid.import uid_list

    record_completion

    UidDecodingChannel.broadcast_to(id, 'success')
  end
  # rubocop:enable Metrics/MethodLength
end
