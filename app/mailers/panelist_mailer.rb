# frozen_string_literal: true

# Send email to panelists
class PanelistMailer < ApplicationMailer
  default from: 'support@op4g.com'

  def email_confirmation_reminder(panelist)
    @panelist = panelist

    mail(
      to: @panelist.email,
      subject: 'We noticed you never finished signing up!'
    )
  end

  def demographic_completion_reminder(panelist)
    @panelist = panelist

    mail(
      to: @panelist.email,
      subject: 'We noticed you never finished your $2 demographic survey!'
    )
  end
end
