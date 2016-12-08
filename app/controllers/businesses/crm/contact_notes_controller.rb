class Businesses::Crm::ContactNotesController < Businesses::BaseController
  before_action do
    @contact = @business.contacts.find(params[:contact_id])
  end

  before_action only: new_actions do
    @contact_note = @contact.contact_notes.new
  end

  before_action only: member_actions do
    @contact_note = @contact.contact_notes.find(params[:id])
  end

  def create
    create_resource @contact_note, contact_notes_params, location: [:edit, @business, :crm, @contact]
  end

  def update
    update_resource @contact_note, contact_notes_params, location: [:edit, @business, :crm, @contact]
  end

  def destroy
    destroy_resource @contact_note, location: [:edit, @business, :crm, @contact]
  end

  private

  def contact_notes_params
    params.require(:contact_note).permit(
      :content,
    ).tap do |safe_params|
      safe_params[:user_name] = current_user.name
    end
  end
end
