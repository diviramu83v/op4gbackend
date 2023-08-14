# frozen_string_literal: true

# Usage: rails runner lib/scripts/reword_blocked_onboardings_error_messages.rb

start_time = '2021-04-01'.to_datetime.utc
end_time = Time.now.utc

onboardings = Onboarding.blocked.where(created_at: start_time..end_time)

onboardings.find_each do |onboarding|
  reason_blocked = onboarding.error_message if onboarding.error_message.present?

  case reason_blocked
  when 'CleanID: score is too high' then onboarding.update!(error_message: 'CleanID: score too high')
  when 'CleanID: too much time spent on step' then onboarding.update!(error_message: 'CleanID: took too long')
  when 'CleanID: score is missing' then onboarding.update!(error_message: 'CleanID: score missing')
  when 'CleanID: tampering check' then onboarding.update!(error_message: 'CleanID: data tampering')
  when 'CleanID: data is blank' then onboarding.update!(error_message: 'CleanID: no data')
  when 'Recaptcha: too much time spent on step' then onboarding.update!(error_message: 'Recaptcha: took too long')
  when 'Recaptcha: too many checks' then onboarding.update!(error_message: 'Recaptcha: repeat visit')
  end
end
