# frozen_string_literal: true

class Panelist::WelcomesController < Panelist::BaseController
  skip_before_action :verify_welcomed

  # rubocop:disable Metrics/AbcSize
  def show
    @pixels = TrackingPixel.welcome

    current_panelist.update!(welcomed_at: Time.now.utc, status: Panelist.statuses[:active])
    panelist_suspender = PanelistSuspender.new(current_panelist)
    panelist_suspender.auto_suspend
    current_panelist.add_signup_earnings

    SignupReminder.where(panelist: current_panelist).update(status: SignupReminder.statuses[:ignored])
    MadMimiAddToSignupListJob.perform_later(panelist: current_panelist)
  end
  # rubocop:enable Metrics/AbcSize
end
