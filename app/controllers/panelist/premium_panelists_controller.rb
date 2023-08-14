# frozen_string_literal: true

class Panelist::PremiumPanelistsController < Panelist::BaseController
  skip_before_action :authenticate_panelist!
  skip_before_action :set_locale

  skip_before_action :verify_agreed_to_terms
  skip_before_action :verify_clean_id_data_present
  skip_before_action :verify_completed_base_demographics
  skip_before_action :verify_demographic_questions_answered
  skip_before_action :verify_welcomed
  skip_before_action :verify_nonprofit_not_archived

  def new
    @panelist = Panelist.new
  end

  def show
    sign_out
    @panelist = Panelist.find(params[:id])
  end

  def edit
    @panelist = Panelist.find(params[:id])
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def create
    expert_panel = Panel.find_by(slug: 'expert-panel')
    @panelist = Panelist.new(
      panelist_params.merge(
        premium: true,
        country: Country.find_by(slug: 'us'),
        original_panel: expert_panel,
        primary_panel: expert_panel,
        clean_id_data: { data: 'blank' }
      )
    )
    @panelist.skip_confirmation!

    @panelist.password = params[:panelist][:password]
    @panelist.password_confirmation = params[:panelist][:confirm_password]

    if @panelist.save
      @panelist.panel_memberships.create(panel: expert_panel)
      redirect_to initial_signup_url(@panelist)
    else
      render :new
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  def update
    @panelist = Panelist.find(params[:id])

    if @panelist.update(panelist_params)
      redirect_to initial_signup_path(@panelist)
    else
      render :edit
    end
  end

  private

  def panelist_params
    params.require(:panelist).permit(:first_name, :last_name, :email, :id_card)
  end
end
