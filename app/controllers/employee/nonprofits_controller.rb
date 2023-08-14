# frozen_string_literal: true

class Employee::NonprofitsController < Employee::RecruitmentBaseController
  authorize_resource class: 'Nonprofit'

  before_action :load_state_options, only: [:new, :create, :edit, :update]

  def index
    @nonprofits = Nonprofit.active.order_by_name
  end

  def show
    @nonprofit = Nonprofit.find(params[:id])
  end

  def new
    @nonprofit = Nonprofit.new
  end

  def create
    @nonprofit = Nonprofit.new(nonprofit_params)

    if @nonprofit.save
      redirect_to @nonprofit
    else
      render 'new'
    end
  end

  def edit
    @nonprofit = Nonprofit.find(params[:id])
  end

  def update
    @nonprofit = Nonprofit.find(params[:id])

    if @nonprofit.update(nonprofit_params)
      redirect_to @nonprofit
    else
      render 'edit'
    end
  end

  def destroy
    @nonprofit = Nonprofit.find(params[:id])

    if @nonprofit.archive
      flash[:notice] = "Nonprofit archived: #{@nonprofit.name}"

      redirect_to nonprofits_path
    else
      flash[:alert] = "Unable to archive nonprofit: #{@nonprofit.name}"
      render 'show'
    end
  end

  private

  def load_state_options
    @all_state_options = Nonprofit::STATE_OPTIONS
    @selected_state_options = Nonprofit::STATE_OPTIONS['United States']
  end

  # rubocop:disable Naming/VariableNumber
  def nonprofit_params
    params.require(:nonprofit).permit(:name, :mission, :fully_qualified,
                                      :front_page, :address_line_1, :address_line_2, :city, :state, :zip_code,
                                      :country_id, :phone, :url, :ein, :contact_name, :contact_title,
                                      :contact_phone, :contact_email, :created_at,
                                      :updated_at, :manager_name, :manager_email, :logo)
  end
  # rubocop:enable Naming/VariableNumber
end
