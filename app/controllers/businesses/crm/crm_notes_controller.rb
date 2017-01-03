class Businesses::Crm::CrmNotesController < Businesses::BaseController
  before_action do
    if params[:contact_id].nil?
      @related_entity = @business.owned_companies.find(params[:company_id])
      @company = @business.owned_companies.find(params[:company_id])
    else
      @related_entity = @business.contacts.find(params[:contact_id])
      @contact = @business.contacts.find(params[:contact_id])
    end
  end

  before_action only: new_actions do
    @crm_note = @related_entity.crm_notes.new
  end

  before_action only: member_actions do
    @crm_note = @related_entity.crm_notes.find(params[:id])
  end

  def create
    create_resource @crm_note, crm_notes_params, location: [:edit, @business, :crm, @related_entity]
  end

  def update
    update_resource @crm_note, crm_notes_params, location: [:edit, @business, :crm, @related_entity]
  end

  def destroy
    destroy_resource @crm_note, location: [:edit, @business, :crm, @related_entity]
  end

  private

  def crm_notes_params
    params.require(:crm_note).permit(
      :content,
    ).tap do |safe_params|
      safe_params[:user_name] = current_user.name
    end
  end
end
