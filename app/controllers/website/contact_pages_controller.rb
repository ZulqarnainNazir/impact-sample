class Website::ContactPagesController < Website::BaseController
  before_action do
    @page = @website.contact_page or raise ActiveRecord::RecordNotFound
    @contact_message = @business.contact_messages.new
  end

  def create
    create_resource @contact_message, contact_message_params, location: :website_contact_page, template: :show
  end

  private

  def contact_message_params
    params.require(:contact_message).permit(
      :customer_name,
      :customer_email,
      :customer_phone,
      :message,
      :honey,
    )
  end
end
