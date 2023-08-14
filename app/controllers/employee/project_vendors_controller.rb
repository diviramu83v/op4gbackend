# frozen_string_literal: true

class Employee::ProjectVendorsController < Employee::OperationsBaseController
  authorize_resource class: 'Project'

  def new
    @project_vendor = ProjectVendor.new(project_id: project.id)
  end

  def create
    @project_vendor = ProjectVendor.new(project_vendor_params)
    @project_vendor.project_id = project.id

    if @project_vendor.save
      flash[:notice] = 'Vendor added to all project surveys.'
      redirect_to project_url(project)
    else
      render action: :new
    end
  end

  private

  def project
    @project ||= Project.find(params[:project_id])
  end

  def project_vendor_params
    params.require(:project_vendor).permit(:vendor_id, :incentive, :quoted_completes, :requested_completes, :complete_url, :terminate_url, :overquota_url,
                                           :security_url)
  end
end
