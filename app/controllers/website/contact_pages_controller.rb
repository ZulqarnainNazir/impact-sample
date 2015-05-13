class Website::ContactPagesController < Website::BaseController
  before_action do
    @page = @website.contact_page

    if !@page
      @redirect = @website.redirects.find_by_from_path(request.path)

      if @redirect
        redirect_to @redirect.to_path, status: 301
      else
        raise ActiveRecord::RecordNotFound
      end
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
      :honey,
    )
  end
end
