# frozen_string_literal: true

# View helpers for panelists.
module PanelistHelper
  # rubocop:disable Metrics/AbcSize
  def panelist_status(panelist)
    return tag.span('signing up', class: 'badge badge-success') if panelist.signing_up?
    return tag.span('active', class: 'badge badge-primary') if panelist.active?
    return tag.span('suspended', class: 'badge badge-danger') if panelist.suspended?
    return tag.span(panelist.status.humanize, class: 'badge badge-warning') if panelist.deactivated? || panelist.deactivated_signup?
    return tag.span('deleted', class: 'badge badge-dark') if panelist.deleted?

    tag.span(panelist.status.humanize, class: 'badge badge-secondary') # default
  end
  # rubocop:enable Metrics/AbcSize

  def nonpayment_client_status(client_status)
    return 'Client reported fraud' if client_status == 'fraudulent'
    return 'Client did not accept answers' if client_status == 'rejected'

    'N/A'
  end
end
