# frozen_string_literal: true

class Employee::FraudulentsController < Employee::OperationsBaseController
  authorize_resource class: 'Onboarding'
  before_action :load_project

  def new; end

  def show
    @decoding = CompletesDecoder.find(params[:id])
  end

  def create # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    @decoding = CompletesDecoder.new(fraudulent_params.merge(employee: current_employee))

    if @decoding.save
      @decoding.decode_uids
      if @decoding.decoded_uids_belong_to_this_project?(@project)
        @decoding.update_onboardings_status('fraudulent')
        @decoding.suspend_panelists_and_block_ips
        redirect_to project_fraudulent_url(@project, @decoding), notice: fraud_notice
      else
        flash.now[:alert] = @decoding.alert_message
        render 'new'
      end
    else
      flash.now[:alert] = 'Unable to decode UIDs.'
      render 'new'
    end
  end

  def destroy
    @decoding = CompletesDecoder.find(params[:id])
    @decoding.update_onboardings_status(nil)
    @decoding.update_onboardings_close_out_reason(nil)
    @decoding.unsuspend_panelists_and_unblock_ips
    @decoding.destroy
    @project.update!(close_out_status: 'waiting')
    redirect_to new_project_fraudulent_url(@project)
  end

  private

  def fraudulent_params
    params.require(:fraudulents).permit(:encoded_uids)
  end

  def load_project
    @project = Project.find(params[:project_id])
  end

  def fraud_notice
    "#{@decoding.onboardings.fraudulent.count} marked as fraudulent"
  end
end
