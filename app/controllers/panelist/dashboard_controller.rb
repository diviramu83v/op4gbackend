# frozen_string_literal: true

class Panelist::DashboardController < Panelist::BaseController
  # rubocop:disable Metrics/AbcSize
  def show
    @open_invitations = current_panelist.invitations.open_invitation.unclicked.oldest_first
    @completed_invitations = current_panelist.invitations.complete.most_recently_completed_first
    @nonprofit = current_panelist.nonprofit

    @completions_in_review = current_panelist.invitations.complete.in_review.oldest_first
    @paid_completions = current_panelist.invitations.complete.paid.newest_first
    @rejected_completions = current_panelist.invitations.complete.rejected.newest_first
  end
  # rubocop:enable Metrics/AbcSize
end
