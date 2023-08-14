class Api::V1::VendorsController < Api::BaseAllowExternalController
  # before_action :authenticate_employee! # test with non authen, please uncomment for production

  def index
    page = params[:page].present? ? params[:page].to_i : 1

    vendors = params[:q].present? ?
      Vendor.search_by_name(params[:q]) :
      Vendor.offset((page - 1) * Vendor::VENDOR_PAGINATE).limit(Vendor::VENDOR_PAGINATE)

    render json: ResponseFormatRepresenter.new(
      success: true,
      code: 200,
      payload: vendors.map {|vd| { id: vd.id, name: vd.name }}
    ), status: :ok
  end
end