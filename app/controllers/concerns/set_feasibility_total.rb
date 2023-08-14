# frozen_string_literal: true

module SetFeasibilityTotal
  include ActiveSupport::Concern

  private

  def save_feasibility_total(query)
    return if query.panel.nil? || query.panelists.nil? || query.survey.present?

    count = query.panelists.count
    query.update!(feasibility_total: count)
  end
end
