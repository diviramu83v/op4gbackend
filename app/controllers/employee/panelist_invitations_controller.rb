# frozen_string_literal: true

class Employee::PanelistInvitationsController < Employee::MembershipBaseController
  before_action :authenticate_access_to_member_data
  authorize_resource class: 'Panelist'

  # rubocop:disable Metrics/AbcSize
  def show
    @panelist = Panelist.find(params[:panelist_id])
    @open_invitations = @panelist.invitations.open_invitation.oldest_first
    @completed_invitations = @panelist.invitations.complete.most_recently_completed_first
    @completions_in_review = @panelist.invitations.complete.in_review.most_recently_completed_first
    @rejected_completions = @panelist.invitations.complete.rejected.most_recently_completed_first
    @paid_completions = @panelist.invitations.complete.paid.most_recently_completed_first
    @nonprofit = @panelist.nonprofit
  end
  # rubocop:enable Metrics/AbcSize
end
