class Businesses::Crm::FeedbacksController < Businesses::BaseController
  before_action -> { confirm_module_activated(3) }
  before_action only: new_actions do
    if params[:contact_id]
      @contact = @business.contacts.find(params[:contact_id])
      @url = [@business, :crm, @contact, :feedbacks]
    else
      @contact = @business.contacts.new
      @url = [@business, :crm, :feedbacks]
    end
    @feedback = @contact.feedbacks.new(business: @business)
  end

  before_action only: member_actions do
    @feedback = @business.feedbacks.find(params[:id])
    @feedback.update_column :read_by, @feedback.read_by + [current_user.id] unless @feedback.read_by.include?(current_user.id)
  end

  def index
    @feedbacks = @business.feedbacks.includes(:contact, :review).where(hide: false).order(feedbacks_order) #.page(params[:page]).per(20)
  end

  def create
    puts params[:feedback][:contact][:id]
    @contact_present = false
    if params[:feedback][:contact][:email].present?
      if @business.contacts.where(email: params[:feedback][:contact][:email]).present?
        @contact_present = true
      end
    end

    if !@contact_present and @contact.new_record?
      @contact.relationship = 'Customer'
      create_resource @contact, contact_params, location: [@business, :crm_contacts] do |success|
        if success
          intercom_event 'added-customer', {
            name: @contact.first_name + " " + @contact.last_name,
            email: @contact.email,
            phone: @contact.phone,
            notes: @contact.crm_notes.first.try(:content),
          }
          # flash[:appcues_event] = "Appcues.track('added contact')"
          if @contact.feedbacks.any?
            # flash[:appcues_event] = "Appcues.track('added contact & requested review')"
            intercom_event 'invited-customer-to-review', {
                contact_name: @contact.first_name + " " + @contact.last_name,
                contact_email: @contact.email,
                contact_phone: @contact.phone,
              serviced_at: @contact.feedbacks.first.try(:serviced_at),
            }
          end
        end
      end
    else
      @feedback.contact = Contact.where(email: params[:feedback][:contact][:email]).first
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
  end

  def destroy
    toggle_resource_boolean_on @feedback, :hide, location: [@business, :crm_feedbacks]
  end

  private

  def feedback_params
    params.require(:feedback).permit(
      :serviced_at,
      :company_id,
      :contact_attributes => [
        :first_name,
        :last_name,
        :email,
      ],
    )
  end

  def contact_params
    params.require(:feedback).require(:contact).permit(
      :first_name,
      :last_name,
      :email,
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
