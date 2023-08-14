# frozen_string_literal: true

class Panelist::NonprofitsController < Panelist::BaseController
  def update
    current_panelist.update!(nonprofit_id: params['nonprofit_id'])
    current_panelist.update!(donation_percentage: 100) if current_panelist.donation_percentage.zero?

    redirect_to account_contribution_path
  end

  def destroy
    current_panelist.update!(nonprofit: nil, donation_percentage: 0)

    redirect_to account_contribution_path, flash: { notice: 'Nonprofit successfully removed.' }
  end
end
