class Businesses::Crm::ContactMessagesController < Businesses::BaseController
  before_action only: member_actions do
    @contact_message = @business.contact_messages.find(params[:id])
  end

  def index
    @contact_messages = @business.contact_messages.includes(:customer).order(contact_messages_order).page(params[:page]).per(20)
  end

  private

  def contact_messages_order
    if %w[serviced_at score].include?(params[:order_by])
      "#{params[:order_by]} #{contact_messages_order_dir} NULLS LAST"
    elsif %w[name].include?(params[:order_by])
      "customers.#{params[:order_by]} #{contact_messages_order_dir} NULLS LAST"
    else
      "updated_at #{contact_messages_order_dir} NULLS LAST"
    end
  end

  def contact_messages_order_dir
    if %w[asc desc].include?(params[:order_dir])
      params[:order_dir]
    else
      'desc'
    end
  end
end
