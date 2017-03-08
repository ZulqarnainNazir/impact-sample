class Businesses::MissionNotesController < Businesses::BaseController
  def update
    @note = Note.find(params[:id])

    if @note.update(note_params)
      redirect_to :back, notice: 'Note updated'
    else
      redirect_to :back, alert: 'Failed to update note'
    end
  end

  def note_params
    params.require(:note).permit(:note)
  end
end
