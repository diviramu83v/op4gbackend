# frozen_string_literal: true

unreminded_unconfirmed_panelists = Panelist.where(confirmed_at: nil)

unreminded_unconfirmed_panelists.find_each do |p|
  next if p.email_confirmation_reminders.any?

  EmailConfirmationReminder.create!(panelist: p, send_at: Time.now.utc)
end
