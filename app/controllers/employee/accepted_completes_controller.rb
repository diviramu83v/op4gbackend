# frozen_string_literal: true

class Employee::AcceptedCompletesController < Employee::OperationsBaseController
  authorize_resource class: 'Onboarding'
  before_action :load_project

  def new; end

  def show
    @decoding = CompletesDecoder.find(params[:id])
  end

  def create
    @decoding = CompletesDecoder.new(accepted_completes_params.merge(employee: current_employee))

    if @decoding.save
      redirect_to project_accepted_complete_url(@project, @decoding)
    else
      flash.now[:alert] = 'Unable to decode UIDs.'
      render 'new'
    end
  end

  def destroy
    @decoding = CompletesDecoder.find(params[:id])
    @decoding.update_onboardings_status(nil)
    @decoding.destroy
    @project.waiting_on_close_out!
    redirect_to new_project_accepted_complete_url(@project)
  end

  private

  def accepted_completes_params
    params.require(:accepted_completes).permit(:encoded_uids)
  end

  def load_project
    @project = Project.find(params[:project_id])
  end
end
