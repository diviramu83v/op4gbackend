# frozen_string_literal: true

# View helpers for onramps.
module OnrampHelper
  def onramp_source_badge(onramp)
    label = badge_label(onramp)
    klass = badge_class(onramp)
    tag.span(label, class: "badge badge-#{klass} mr-1")
  end

  def onramp_prescreener_row_status(onramp)
    'table-primary' if onramp.check_prescreener?
  end

  def uid_tid_pid_param(onramp)
    return 'tid' if onramp.disqo?
    return 'pid' if onramp.schlesinger?

    'uid'
  end

  private

  def badge_label(onramp) # rubocop:disable Metrics/CyclomaticComplexity
    return onramp.category if onramp.testing? || onramp.recontact? || onramp.cint? || onramp.expert_recruit? || onramp.client_sent?
    return "#{onramp.category}: #{onramp.disqo_id}" if onramp.disqo?
    return "#{onramp.category}: #{onramp.id}" if onramp.schlesinger?

    "#{onramp.category}: #{onramp.source_model_name}"
  end

  # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
  def badge_class(onramp)
    return 'success' if onramp.panel?
    return 'success' if onramp.recontact?
    return 'primary' if onramp.vendor?
    return 'secondary' if onramp.router?
    return 'secondary' if onramp.api?
    return 'info' if onramp.testing?
    return 'dark' if onramp.cint? || onramp.disqo? || onramp.schlesinger?
    return 'warning' if onramp.expert_recruit?
    return 'warning' if onramp.client_sent?

    'danger'
  end
  # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
end
