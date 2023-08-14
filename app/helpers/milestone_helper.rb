# frozen_string_literal: true

# View helpers related to survey milestones.
module MilestoneHelper
  def milestone_bar_width(milestone)
    completes = milestone.survey.adjusted_complete_count
    target = milestone.target_completes

    ((completes / target.to_f) * 100).to_i
  end

  def milestone_bar_color(milestone)
    return 'bg-success' if milestone.active?
    return 'bg-secondary' if milestone.inactive?

    'bg-info'
  end

  def milestone_status(milestone)
    return milestone_sent_status(milestone) if milestone.sent?

    milestone.status.humanize
  end

  private

  def milestone_sent_status(milestone)
    content = []
    content << 'Sent: '
    content << format_long_date(milestone.sent_at)
    safe_join(content)
  end
end
