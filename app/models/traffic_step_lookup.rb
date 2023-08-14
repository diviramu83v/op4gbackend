# frozen_string_literal: true

# a traffic step lookup is used to match uids to an onboarding's traffic steps link
class TrafficStepLookup < ApplicationRecord
  validates :uids, presence: true

  def split_uids
    uids.gsub("\r\n", ' ').tr(',', ' ').split
  end

  def uid_onboardings
    uid_onboardings = {}

    split_uids.each do |uid|
      onboarding = Onboarding.find_by(uid: uid)
      next if onboarding.blank?

      uid_onboardings[uid] = onboarding
    end
    uid_onboardings
  end

  def uids_not_found
    split_uids - uid_onboardings.keys
  end
end
