class Api::V1::CountriesController < Api::BaseAllowExternalController
  # before_action :authenticate_employee! # test with non authen, please uncomment for production

  def index
    # paginate
    # page = params[:page].present? ? params[:page].to_i : 1
    # countries = params[:q].present? ?
    #   Country.search_by_name(params[:q]) :
    #   Country.offset((page - 1) * Country::COUNTRY_PAGINATE).limit(Country::COUNTRY_PAGINATE)

    render json: ResponseFormatRepresenter.new(
      success: true,
      code: 200,
      payload: Country.all.as_json(except: [:nonprofit_flag, :slug, :created_at, :updated_at])
    ), status: :ok
  end
end