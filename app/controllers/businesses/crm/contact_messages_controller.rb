class Businesses::Crm::ContactMessagesController < Businesses::BaseController
  before_action only: member_actions do
    @contact_message = @business.contact_messages.find(params[:id])
    @contact_message.update_column :read_by, @contact_message.read_by + [current_user.id] unless @contact_message.read_by.include?(current_user.id)
  end

  def index
    @contact_messages = @business.contact_messages.includes(:customer).where(hide: false).order(contact_messages_order).page(params[:page]).per(20)
  end

  def destroy
    toggle_resource_boolean_on @contact_message, :hide, location: [@business, :crm_contact_messages]
  end

  private

  def contact_messages_order
    if %w[created_at serviced_at score].include?(params[:order_by])
      "#{params[:order_by]} #{contact_messages_order_dir} NULLS LAST"
    elsif %w[name].include?(params[:order_by])
      "customers.#{params[:order_by]} #{contact_messages_order_dir} NULLS LAST"
    else
      'CASE WHEN cardinality(read_by) = 0 THEN 0 ELSE 1 END ASC, updated_at DESC'
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
