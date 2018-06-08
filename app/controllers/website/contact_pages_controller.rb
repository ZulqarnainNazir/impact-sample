class Website::ContactPagesController < Website::BaseController
  include Recaptcha::Verify

  before_action do
    @page = @website.contact_page or raise ActiveRecord::RecordNotFound
    @contact_message = @business.contact_messages.new
    get_content_types("BlogFeedGroup", @page)
  end

  def create
    if verify_recaptcha(model: @contact_message)
      create_resource @contact_message, contact_message_params, location: :website_contact_page, template: :show
    else
      flash[:alert] = "You do not appear to be human, or you forgot to answer the recaptcha prompt"
      redirect_to :back
    end
  end

  private

  def contact_message_params
    params.require(:contact_message).permit(
      :customer_first_name,
      :customer_last_name,
      :customer_email,
      :customer_phone,
      :message,
      :honey,
    )
  end
end
