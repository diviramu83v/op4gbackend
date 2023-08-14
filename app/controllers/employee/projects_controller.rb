# frozen_string_literal: true

class Employee::ProjectsController < Employee::OperationsBaseController
  authorize_resource

  def index
    store_project_filters(params)
    @status = session[:status]
    @projects = projects_for_status(@status)
    @projects = projects_for_filter(@effective_role)
    @projects = @projects.page(params[:page]).per(50)
    @project_report = ProjectReport.last
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params.merge(manager: current_employee))

    if @project.save
      @project.add_survey if @project.surveys.empty?
      redirect_to edit_project_path(@project)
    else
      render 'new'
    end
  end

  def show
    @project = Project.find(params[:id])
  end

  def edit
    @project = Project.find(params[:id])

    redirect_to @project, alert: 'Unable to edit project.' unless @project.editable?
  end

  def update
    @project = Project.find(params[:id])

    if @project.update(project_params)
      redirect_to @project
    else
      render 'edit'
    end
  end

  private

  def store_project_filters(params)
    handle_projects_session(params)
    handle_status_session(params)
    handle_page_param(params)
  end

  def handle_projects_session(params)
    session[:projects] = params[:projects] || session[:projects] || 'all'
    session[:projects] = 'mine' unless can?(:read, Project)
  end

  def handle_status_session(params)
    session[:status] = 'active' if session[:status].blank?
    session[:status] = params[:status] if params[:status].present?
  end

  def handle_page_param(params)
    params[:page] = 1 if params[:projects].present? && session[:projects] != params[:projects]
    params[:page] = 1 if params[:status].present? && session[:status] != params[:status]
  end

  def project_params
    params.require(:project).permit(:name, :manager_id, :work_order,
                                    :salesperson_id, :client_id,
                                    :notes, :rtf_notes, :relevant_id_level,
                                    :product_name, :unbranded, :estimated_start_date,
                                    :estimated_complete_date, :start_date, :complete_date
                                  )
  end

  def projects_for_status(status)
    case status
    when 'all'    then Project.all
    when 'active' then Project.joins(:surveys).merge(Survey.active).distinct
    else Project.joins(:surveys).where(surveys: { status: status }).distinct
    end.order('projects.id DESC').includes(:manager, :client, :salesperson, :surveys)
  end

  def projects_for_filter(effective_role)
    case session[:projects]
    when 'mine' then projects_for_employee(effective_role)
    else @projects
    end
  end

  def projects_for_employee(effective_role)
    if current_user.operations_employee?(effective_role)
      @projects.for_manager(current_employee)
    else
      @projects.for_salesperson(current_employee)
    end
  end
end
