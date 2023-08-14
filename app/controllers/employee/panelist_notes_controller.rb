# frozen_string_literal: true

class Employee::PanelistNotesController < Employee::MembershipBaseController
  authorize_resource class: 'Panelist'

  def new
    @panelist = Panelist.find(params[:panelist_id])

    @note = PanelistNote.new
  end

  def create
    @panelist = Panelist.find(params[:panelist_id])

    @note = @panelist.notes.new(note_params.merge(employee: current_employee))

    if @note.save
      redirect_to panelist_path(@panelist)
    else
      render :new
    end
  end

  private

  def note_params
    params.require(:panelist_note).permit(:body)
  end
end
