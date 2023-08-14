# frozen_string_literal: true

# Usage: rails runner lib/scripts/suspend_panelists/suspend_suspected_bots.rb

uids = %w[
  k6k1sJqw1HPP7XF45WTTMSUi ZRxahbV67uwdfUtNnu9NBjV2 BztHFnah7xNGXNqB6YA2WB3Z 6wbTviFkLViTmAAMrWQRYJC1 sCiBc7XhYYeM4sHxU3k1WTT3 cBHA25PtmVRkyQQd3LXvicL4
  L3k3u9brXGpHwCj1bKzw5Ezo rx1c4kLCrGPQgYnk53oakeb3 meZ7wohoR8TvmcE9ZBsF4k1t LXegSEQjox4xSdKxQT6nQzjA bu2pWdmZvhdAivACZz93inBE BVRRuSdoPiryNN96XP4fzQbU
  mh6eJ3JfXwxRGPMc4CgsoD98 fFxW2G9h9fc8kofDDSpyqAR5 BspuAHHoExgqBVZHHB6Bjriw W396DZgCr1SqtSw7U8ojuikL j8jZpqYRGfwbj43hiQNc1g3g QzsPbYwpcuy6WkWKRjmPS5i5
  s4xtX6ziAU9UsMpx17MxbjiG MhUqFx4BK38izo2pLwZCNW3J 4wj69H1856CoPpQe91EtYCk8 L6uQDEVkHn8w5ZF4SsJScVNF xU7Qx1fJcyR81s4K8G9t6WTo eLxUFnat1D58339MihkDaSSw
  8ybJYPnq4RnmygAfGGDRQ4EP SarntiR3UTrk1RZwHaW4KgZm 7MD3i8CMQs8wNhdf5aunBTo2 4wYkAAVY8x4Nji5jhZX3Gjvn AnGCLqaBFwrDXhnBWZy7Af56 fZJu1dzbZkfyWFSMttK7PZ5i
  cTKG2fSHh4gkAY7fEEyqT1Hk GHfkvgmFcfTZVhzXjNE5evhC LnfUThdWkpRUFybR9kJ8uRYB 2jwVoaRJFGUHyaNt2oobxQYK 24jqf5oiLWVTH4i1mqV9hMFj tUkxVjxjYBjY7aENqayAPSLE
  nok8W1vNcweXobEasruVQyKL syXxAfuzYaksn1jwC99nwD55 9f8LUduE5YK9qJgjJoEqwsRA 59AoXDsHSLEKKWwQPtfQ6xwn pqsFutYaSwkqC9oM2iDQdC42 uC5ZAmHCFmhBMEFovQiFwPma
  You5pEVzYaWpBwy6gFS8HCMB rwkKbuSas7Z25gDSBTpcsNgb GqvLdBo8yDPmFcZDKQ28jyNY 8tsUrCcutA473eXmEhCCDqt9 ju8qrdDzFt8s8TMwJ64AP2q4 kABP6AKowadUPmXW7jjALerA
  Q2KExbUDiqhRE8c5R1rzLRJx mMqcTtkQ9oaxYjY5No7xiYsh egEh4HSB2aUWUXVSPqca3BJb LCaRwmkPEPDwH4X4KpnPUiue
]

count = 0

onboardings = []

uids.each do |uid|
  onboarding = Onboarding.find_by(uid: uid)
  next if onboarding.blank?

  onboardings << onboarding
end

panelists = []

onboardings.each do |onboarding|
  next if onboarding.panelist.blank?

  panelists << onboarding.panelist
end

panelists.each do |panelist|
  next if panelist.blank?

  panelist.suspend unless panelist.suspended?

  panelist.notes.create!(employee_id: 0, body: 'Suspended per Josh Giles: Suspected bot, Panel_WO62997_Asset Managers Unmoderated IA Test_(20158)')

  count += 1

rescue ActiveRecord::RecordInvalid
  # rubocop:disable Rails/SkipsModelValidations
  unless panelist.suspended?
    panelist.update_columns(
      suspended_at: Time.now.utc,
      status: Panelist.statuses[:suspended]
    )
  end
  # rubocop:enable Rails/SkipsModelValidations

  panelist.notes.create!(employee_id: 0, body: 'Suspended per Josh Giles: Suspected bot, Panel_WO62997_Asset Managers Unmoderated IA Test_(20158)')

  count += 1
end

puts "#{count} panelists were suspended."
