class Businesses::Crm::FeedbacksController < Businesses::BaseController
  before_action only: new_actions do
    @contact = @business.contacts.find(params[:contact_id])
    @feedback = @contact.feedbacks.new(business: @business)
  end

  before_action only: member_actions do
    @feedback = @business.feedbacks.find(params[:id])
    @feedback.update_column :read_by, @feedback.read_by + [current_user.id] unless @feedback.read_by.include?(current_user.id)
  end

  def index
    @feedbacks = @business.feedbacks.includes(:contact, :review).where(hide: false).order(feedbacks_order).page(params[:page]).per(20)
  end

  def create
    create_resource @feedback, feedback_params, location: [@business, :crm_contacts] do |success|
      if success
        intercom_event 'invited-customer-to-review', {
            contact_name: @feedback.contact.name,
          contact_email: @feedback.contact.email,
          contact_phone: @feedback.contact.phone,
          serviced_at: @feedback.serviced_at,
        }
      end
    end
  end

  def destroy
    toggle_resource_boolean_on @feedback, :hide, location: [@business, :crm_feedbacks]
  end

  private

  def feedback_params
    params.require(:feedback).permit(
      :serviced_at,
      :company_id,
    )
  end

  def feedbacks_order
    if %w[serviced_at score].include?(params[:order_by])
      "#{params[:order_by]} #{feedbacks_order_dir} NULLS LAST"
    elsif %w[name].include?(params[:order_by])
      "contacts.#{params[:order_by]} #{feedbacks_order_dir} NULLS LAST"
    else
      'CASE WHEN cardinality(read_by) = 0 THEN 0 ELSE 1 END ASC, updated_at DESC'
    end
  end

  def feedbacks_order_dir
    if %w[asc desc].include?(params[:order_dir])
      params[:order_dir]
    else
      'desc'
    end
  end
end
