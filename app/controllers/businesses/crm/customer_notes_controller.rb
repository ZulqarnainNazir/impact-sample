class Businesses::Crm::CustomerNotesController < Businesses::BaseController
  before_action do
    @customer = @business.customers.find(params[:customer_id])
  end

  before_action only: new_actions do
    @customer_note = @customer.customer_notes.new
  end

  before_action only: member_actions do
    @customer_note = @customer.customer_notes.find(params[:id])
  end

  def create
    create_resource @customer_note, customer_note_params, location: [:edit, @business, :crm, @customer]
  end

  def update
    update_resource @customer_note, customer_note_params, location: [:edit, @business, :crm, @customer]
  end

  def destroy
    destroy_resource @customer_note, location: [:edit, @business, :crm, @customer]
  end

  private

  def customer_note_params
    params.require(:customer_note).permit(
      :content,
    ).tap do |safe_params|
      safe_params[:user_name] = current_user.name
    end
  end
end
