class Api::V1::ProjectsController < Api::BaseAllowExternalController
  # before_action :authenticate_employee! # test with non authen, please uncomment for production

  def index
    page = params[:page].present? ? params[:page].to_i : 1

    projects = params[:q].present? ?
      Project.search_by_name_any_word(params[:q]).offset((page - 1) * Project::PROJECT_PAGINATE).limit(Project::PROJECT_PAGINATE) :
      Project.offset((page - 1) * Project::PROJECT_PAGINATE).limit(Project::PROJECT_PAGINATE)

    projects = projects.pluck(:id, :name).map{ |p| { id: p[0], name: p[1] } }

    render json: ResponseFormatRepresenter.new(
      success: true,
      code: 200,
      payload: projects.as_json
    ), status: :ok
  end
end