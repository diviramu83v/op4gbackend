# frozen_string_literal: true

class Employee::RecontactInvitationBatchesController < Employee::OperationsBaseController
  authorize_resource class: 'Onboarding'
  authorize_resource

  before_action :load_recontact, only: [:new, :create]

  def new
    @recontact_invitation_batch = RecontactInvitationBatch.new
  end

  def edit
    @recontact_invitation_batch = RecontactInvitationBatch.find(params[:id])
    @recontact = @recontact_invitation_batch.survey
    @project = @recontact.project
  end

  def create
    data = get_csv_data(recontact_invitation_batch_params[:uids_urls])

    @recontact_invitation_batch = @recontact.invitation_batches.new(survey: @recontact, csv_data: data)
    @recontact_invitation_batch.save
    redirect_to recontact_url(@recontact, batch_id: @recontact_invitation_batch)
  end

  def update
    @recontact_invitation_batch = RecontactInvitationBatch.find(params[:id])
    @recontact = @recontact_invitation_batch.survey
    @project = @recontact.project
    if @recontact_invitation_batch.update(recontact_invitation_batch_params)
      redirect_to recontact_url(@recontact)
    else
      render 'edit'
    end
  end

  private

  def get_csv_data(file)
    csv_data = {}

    CSV.foreach(file.path) do |row|
      csv_data.merge!({ row[0] => row[1] })
    end

    csv_data.to_json
  end

  def load_recontact
    @recontact = Survey.find(params[:recontact_id])
  end

  def recontact_invitation_batch_params
    params.require(:recontact_invitation_batch).permit(:uids_urls, :incentive, :subject, :email_body)
  end
end
