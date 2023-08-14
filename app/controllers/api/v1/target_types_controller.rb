class Api::V1::TargetTypesController < Api::BaseAllowExternalController
  # before_action :authenticate_employee! # test with non authen, please uncomment for production

  def index
    target_types = TargetType.all

    render json: ResponseFormatRepresenter.new(
      success: true,
      code: 200,
      payload: target_types.as_json(except: [:created_at, :updated_at])
    ), status: :ok
  end
end