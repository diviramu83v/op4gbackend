# frozen_string_literal: true

# View helpers for project pages and cards.
module ProjectHelper
  def project_link(project)
    return '?' if project.blank?

    # TODO: Check permissions with cancancan here. (link_to_if)
    link_to project.name, project
  end

  def survey_status_badge(status)
    tag.span("survey: #{status}",
             class: "badge badge-#{survey_status_class(status)}")
  end

  def survey_status_class(status)
    styles = {
      'active' => 'secondary',
      'draft' => 'dark',
      'live' => 'primary',
      'hold' => 'danger',
      'waiting' => 'warning',
      'finished' => 'success',
      'archived' => 'info'
    }

    styles[status]
  end

  # rubocop:disable Metrics/MethodLength
  def cint_survey_status_class(status)
    styles = {
      'draft' => 'dark',
      'activation_failed' => 'danger',
      'waiting' => 'warning',
      'live' => 'primary',
      'paused' => 'secondary',
      'halted' => 'secondary',
      'complete' => 'success',
      'closed' => 'secondary'
    }

    styles[status]
  end
  # rubocop:enable Metrics/MethodLength

  def expert_recruit_batch_status_class(status)
    styles = {
      'waiting' => 'warning',
      'sent' => 'success'
    }

    styles[status]
  end

  def active_class?(session_variable, status)
    'active' if session[session_variable.to_sym] == status
  end

  def project_close_out_label(close_out_status)
    case close_out_status
    when 'waiting_on_close_out' then 'waiting'
    else
      close_out_status
    end
  end

  def project_close_out_details_link(onramp)
    return survey_disqo_quotas_url(onramp.survey) if onramp.disqo?
    return survey_cint_surveys_url(onramp.survey) if onramp.cint?

    survey_vendors_url(onramp.survey)
  end

  def close_out_fraud_reasons
    CloseOutReason.frauds.where.not(definition: nil).map do |reason|
      content_tag(:div, content_tag(:p, "#{reason.title}: " + reason.definition), style: 'text-align:left')
    end.join
  end

  def close_out_rejected_reasons
    CloseOutReason.rejected.where.not(definition: nil).map do |reason|
      content_tag(:div, content_tag(:p, "#{reason.title}: " + reason.definition), style: 'text-align:left')
    end.join
  end
end
