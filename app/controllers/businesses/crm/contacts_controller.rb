class Businesses::Crm::ContactsController < Businesses::BaseController
  before_action only: new_actions do
    @contact = @business.contacts.new
  end

  before_action only: member_actions do
    @contact = @business.contacts.find(params[:id])
    @contact.update_column :read_by, @contact.read_by + [current_user.id] unless @contact.read_by.include?(current_user.id)
  end

  def index
    scope = @business.contacts.includes(:feedback).where(hide: false)
    query = params[:query].to_s.strip

    if query.present?
      scope = scope.where("CONCAT_WS(' ', first_name, last_name) ILIKE ? OR business_name ILIKE ?", "%#{query}%", "%#{query}%")
    end

    @contacts = scope.order(contacts_order) #.page(params[:page]).per(20)
  end

  def create
    @contact.relationship = params[:contact][:relationship]
    create_resource @contact, contact_params, location: [@business, :crm_contacts] do |success|
      if success
        intercom_event 'added-customer', {
          name: @contact.first_name + " " + @contact.last_name,
          email: @contact.email,
          phone: @contact.phone,
          notes: @contact.crm_notes.first.try(:content),
        }
        if @contact.feedbacks.any?
          intercom_event 'invited-customer-to-review', {
              contact_name: @contact.first_name + " " + @contact.last_name,
              contact_email: @contact.email,
              contact_phone: @contact.phone,
            serviced_at: @contact.feedbacks.first.try(:serviced_at),
          }
        end
      end
    end
  end

  def update
    @contact.relationship = params[:contact][:relationship]
    if @contact.update_attributes contact_params
      redirect_to [:edit, @business, :crm, @contact], :notice => "Successfully Saved Contact"
    else
      redirect_to [:edit, @business, :crm, @contact], :notice => "Failed to Save Contact"
    end
  end

  def destroy
    if @contact.reviews.empty?
      destroy_resource @contact, location: [@business, :crm_contacts]
    else
      redirect_to [@business, :crm_contacts], :notice => "Cannot Delete Contact with Reviews"
    end
  end

  private

  def contact_params
    params.require(:contact).permit(
      :first_name,
      :last_name,
      :email,
      :street1,
      :street2,
      :city,
      :state,
      :zip,
      :relationship,
      :phone,
      :description,
      :business_client,
      :business_name,
      :business_url,
      {:company_ids => []},
      crm_notes_attributes: [
        :content,
      ],
      feedbacks_attributes: [
        :serviced_at,
        :_destroy,
      ],
    ).tap do |safe_params|
      if safe_params[:crm_notes_attributes]
        safe_params[:crm_notes_attributes].map do |_, attr|
          attr[:user_name] = current_user.name if attr[:content].present?
        end
      end
      if safe_params[:feedbacks_attributes]
        safe_params[:feedbacks_attributes].map do |_, attr|
          attr[:business] = @business
          attr[:_destroy] = '1' if params[:_inverse_destroy] != '1'
        end
      end
    end
  end

  def contacts_order
    if %w[first_name last_name email phone].include?(params[:order_by])
      "#{params[:order_by]} #{contacts_order_dir} NULLS LAST"
    elsif %w[serviced_at completed_at score].include?(params[:order_by])
      "feedbacks.#{params[:order_by]} #{contacts_order_dir} NULLS LAST"
    else
      'CASE WHEN cardinality(read_by) = 0 THEN 0 ELSE 1 END ASC, updated_at DESC'
    end
  end

  def contacts_order_dir
    if %w[asc desc].include?(params[:order_dir])
      params[:order_dir]
    else
      'desc'
    end
  end
end
