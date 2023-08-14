# frozen_string_literal: true

class Panelist::BaseDemographicsController < Panelist::BaseController
  skip_before_action :verify_completed_base_demographics
  skip_before_action :verify_demographic_questions_answered
  skip_before_action :verify_welcomed

  before_action :verify_base_info

  def show; end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def create
    if current_panelist.update(base_demo_params)
      if current_panelist.demos_completed?
        redirect_back(fallback_location: panelist_dashboard_path)
      else
        redirect_to demographics_url
      end
    else
      render :show
    end
  rescue ArgumentError => e
    current_panelist.errors.add(:birthdate, e.message)
    render :show
  rescue RangeError
    current_panelist.errors.add(:birthdate, 'Unable to process birthdate fields.')
    render :show
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  private

  def base_demo_params
    params.require(:base_demographics).permit(:address, :address_line_two, :city, :state, :postal_code, :business_name).merge(birthdate)
  end

  def birthdate
    date = "#{params.dig(:base_demographics, :year)}-#{params.dig(:base_demographics, :month)}-#{params.dig(:base_demographics, :day)}"
    { birthdate: Date.parse(date) }
  end

  def verify_base_info
    redirect_to panelist_dashboard_path if current_panelist.base_demo_questions_completed?
  end
end
