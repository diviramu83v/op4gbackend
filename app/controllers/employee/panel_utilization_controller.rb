# frozen_string_literal: true

class Employee::PanelUtilizationController < Employee::RecruitmentBaseController
  authorize_resource class: 'Panel'

  def show # rubocop:disable Metrics/AbcSize
    # These queries were necessary to get the data for the panel utilization as the panel and survey models do not have a direct relationship
    @panel = Panel.find(params[:panel_id])
    live_survey_ids = Survey.standard.live.select(:id).distinct.pluck(:id)
    @panel_survey_ids = @panel.invitations.select(:survey_id).where(survey_id: live_survey_ids).distinct.pluck(:survey_id)

    @surveys = Survey.where(id: @panel_survey_ids).order(started_at: :desc).page(params[:page]).per(25)
  end
end
