# frozen_string_literal: true

class Employee::PanelPanelistsController < Employee::RecruitmentBaseController
  authorize_resource class: 'Panelist'

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def index
    @panel = Panel.find(params[:panel_id])
    @panelists_group = params[:panelists]
    @panelists = case params[:panelists]
                 when 'screened'
                   @panel.panelists.have_been_screened_out_recently
                 when 'no_invitations'
                   @panel.panelists.have_not_received_an_invitation_in_5_months
                 else
                   @panel.panelists.active
                 end

    respond_to do |format|
      format.html
      format.csv do
        generate_panelists_csv(@panelists)
      end
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize
end
