# frozen_string_literal: true

class Employee::RejectedCompletesController < Employee::OperationsBaseController
  authorize_resource class: 'Onboarding'
  before_action :load_project

  def new; end

  def show
    @decoding = CompletesDecoder.find(params[:id])
  end

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def create
    upload_file = params[:rejected_completes]

    if upload_file.blank?
      flash[:alert] = 'No upload file selected.'
      redirect_to new_project_rejected_complete_url
      return
    end

    @decoding = CompletesDecoder.new(rejected_completes_params.merge(employee: current_employee))

    if @decoding.save
      @decoding.decode_uids_from_file(tokens_and_rejected_reasons)

      if @decoding.decoded_uids_belong_to_this_project?(@project)
        @decoding.update_onboardings_status('rejected')
        add_rejected_reason_to_onboarding
        redirect_to project_rejected_complete_url(@project, @decoding), notice: rejected_notice
      else
        flash.now[:alert] = @decoding.alert_message
        render 'new'
      end
    else
      flash.now[:alert] = 'Unable to decode UIDs.'
      render 'new'
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  def destroy
    @decoding = CompletesDecoder.find(params[:id])
    @decoding.update_onboardings_status(nil)
    @decoding.update_onboardings_close_out_reason(nil)
    @decoding.destroy
    @project.waiting_on_close_out!
    redirect_to new_project_rejected_complete_url(@project)
  end

  def add_rejected_reason_to_onboarding
    data = JSON.parse(tokens_and_rejected_reasons)

    data.each do |record|
      token = record.first
      reason = record.last
      onboarding = Onboarding.find_by(token: token)
      onboarding&.update(rejected_reason: reason)
    end
  end

  def tokens_and_rejected_reasons
    upload_file = params[:rejected_completes][:encoded_uids]
    get_csv_data(upload_file) if upload_file.present?
  end

  private

  def rejected_completes_params
    params.require(:rejected_completes).permit(:encoded_uids)
  end

  def load_project
    @project = Project.find(params[:project_id])
  end

  def rejected_notice
    "#{@decoding.onboardings.rejected.count} marked as rejected"
  end

  def get_csv_data(file)
    CSV.foreach(file.path, encoding: 'bom|utf-8').with_object({}) do |row, hash|
      next if row.blank?

      hash[row[0]] = row[1]
    end.to_json
  end
end
