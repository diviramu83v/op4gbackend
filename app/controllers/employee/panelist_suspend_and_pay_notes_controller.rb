# frozen_string_literal: true

class Employee::PanelistSuspendAndPayNotesController < Employee::MembershipBaseController
  authorize_resource class: 'Panelist'

  def new
    @panelist = Panelist.find(params[:panelist_id])

    @note = PanelistNote.new
  end

  def create
    @panelist = Panelist.find(params[:panelist_id])
    @panelist.suspend_and_pay

    suspender = PanelistSuspender.new(@panelist)

    if suspender.manual_suspend!(employee: current_employee, note_body: note_params[:body])
      redirect_to panelist_path(@panelist)
    else
      @note = suspender.note
      render :new
    end
  end

  private

  def note_params
    params.require(:panelist_note).permit(:body)
  end
end
