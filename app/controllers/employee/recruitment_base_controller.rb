# frozen_string_literal: true

class Employee::RecruitmentBaseController < Employee::BaseController
  layout 'recruitment'
  before_action :set_nav_section

  private

  def generate_panelists_csv(panelists)
    csv_file = CSV.generate do |csv|
      csv << %w[Name Email Net_Incentive_Margin Status]
      panelists.each do |panelist|
        csv << [panelist.name, panelist.email, panelist.net_profit, panelist.status.humanize]
      end
    end

    send_data csv_file
  end

  def set_nav_section
    @active_nav_section = 'recruitment'
  end
end
