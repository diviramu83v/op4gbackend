# frozen_string_literal: true

class Employee::DemoQueryProjectInclusionsController < Employee::BaseController
  include RenderDemoQuery

  authorize_resource class: 'DemoQuery'

  def create
    @query = DemoQuery.find(params[:query_id])
    @project_inclusion = @query.project_inclusions.create(project_params)

    unless @project_inclusion.save
      flash.now[:alert] = 'Unable to add project filter'
      @query.project_inclusions.delete(@project_inclusion)
    end

    render json: render_demo_query_traffic
  end

  def destroy
    @query = DemoQuery.find(params[:query_id])
    @project_inclusion = DemoQueryProjectInclusion.find_by(id: params[:id])

    flash.now[:alert] = 'Unable to remove project ID filter' if @project_inclusion.present? &&
                                                                @query.project_inclusions.delete(@project_inclusion)

    render json: render_demo_query_traffic
  end

  def project_params
    params.require(:demo_query_project_inclusion).permit(:project_id, :slug)
  end
end
