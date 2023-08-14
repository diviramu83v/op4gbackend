# frozen_string_literal: true

# A decoded UID record keeps track of one record that is being decoded.
class CompletesDecoder < ApplicationRecord
  include SharedDecoders

  belongs_to :employee

  has_many :decoded_uids, as: :decodable, dependent: :destroy
  has_many :projects, through: :decoded_uids
  has_many :vendors, through: :decoded_uids
  has_many :onboardings, through: :decoded_uids

  validates :encoded_uids, presence: true

  # rubocop:disable Metrics/MethodLength
  def decode_uids
    return if decoded?

    uids = encoded_uids.split(/\n/).map(&:strip).compact_blank
    uid_list = []
    uids.each_with_index do |uid, index|
      new_decoded_uid = DecodedUid.new(
        uid: uid,
        decodable_id: id,
        decodable_type: 'CompletesDecoder',
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

  # rubocop:disable Metrics/MethodLength
  def decode_uids_from_file(file)
    data = JSON.parse(file)
    uids = data.keys
    uid_list = []
    uids.each_with_index do |uid, index|
      new_decoded_uid = DecodedUid.new(
        uid: uid,
        decodable_id: id,
        decodable_type: 'CompletesDecoder',
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

  def update_onboardings_close_out_reason(reason_id)
    onboardings.find_each do |onboarding|
      onboarding.update!(close_out_reason_id: reason_id)
    end
  end
end
