class Website::ContactPagesController < Website::BaseController
  before_action do
    @page = @website.contact_page

    if !@page
      raise ActiveRecord::RecordNotFound
    elsif !@page.active? && !@business.owners.include?(current_user)
      raise ActiveRecord::RecordNotFound
    end

    @contact_message = @business.contact_messages.new
  end

  def create
    create_resource @contact_message, contact_message_params, location: :website_contact_page, template: :show
  end

  private

  def contact_message_params
    params.require(:contact_message).permit(
      :name,
      :email,
      :message,
    )
  end
end
