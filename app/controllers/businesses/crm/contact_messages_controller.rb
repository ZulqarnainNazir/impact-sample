class Businesses::Crm::ContactMessagesController < Businesses::BaseController
  before_action only: member_actions do
    @contact_message = @business.contact_messages.find(params[:id])
  end

  def index
    @contact_messages = @business.contact_messages.chronological
  end
end
