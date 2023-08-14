# frozen_string_literal: true

class Employee::NonprofitPanelistsController < Employee::RecruitmentBaseController
  authorize_resource class: 'Nonprofit'

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def index
    @nonprofit = Nonprofit.find(params[:nonprofit_id])
    @panelists = if params[:incomplete_demos]
                   @nonprofit.panelists.signing_up.where.not(confirmed_at: nil)
                 else
                   @nonprofit.active_current_panelists
                 end

    respond_to do |format|
      format.html
      format.csv do
        csv_file = CSV.generate do |csv|
          csv << ['Name', 'Email', 'Status', 'Donation percentage']
          @panelists.each do |panelist|
            csv << [panelist.name, panelist.email, panelist.status.humanize, panelist.donation_percentage]
          end
        end
        send_data csv_file
      end
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize
end
