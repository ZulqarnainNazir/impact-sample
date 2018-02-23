class Businesses::Crm::ContactFormsController < Businesses::BaseController
  before_action -> { confirm_module_activated(4) }, except: :index
  before_action only: member_actions do
    @contact_form = @business.contact_forms.where(archived: false).find(params[:id])
    @form_fields = FormField.all
    @layout_options = layout_options
  end

  def new
    @contact_form = @business.contact_forms.new
    @contact_form.form_field_ids = FormField.where(:default => true).ids
    @form_fields = FormField.all
    @layout_options = layout_options
  end

  def index
    scope = @business.contact_forms.where(archived: false)
    query = params[:query].to_s.strip

    if query.present?
      scope = scope.where('name ILIKE ?', "%#{query}%")
    end

    @contact_forms = scope.page(params[:page]).per(20)
  end

  def create
    @contact_form = @business.contact_forms.new
    create_resource @contact_form, contact_form_params, location: [:edit, @business, :crm, @contact_form] do |success|
      if success
        flash[:appcues_event] = "Appcues.track('added form')"
        intercom_event 'added-form'
      end
    end
  end

  def update
    contact_form = @business.contact_forms.find(params[:id])
    if contact_form.update_attributes(contact_form_params)
      redirect_to [:edit, @business, :crm, @contact_form], :flash => { :notice => "Form Saved Successfully" }
    else
      redirect_to [:edit, @business, :crm, @contact_form], :flash => { :notice => "Form Failed to Save" }
    end
  end

  def destroy
    toggle_resource_boolean_on @contact_form, :archived, location: [@business, :crm_contact_forms]
    # destroy_resource @contact_form, location: [@business, :crm_contact_forms]
    # ContactForm.destroy(@contact_form.id)
    # redirect_to [@business, :crm_contact_forms]
  end

  private

  def contact_form_params
    params.require(:contact_form).permit(:name, :public_label, :company_list_id, :layout, :public_description, :form_field_ids => [],
                                         :contact_form_form_fields_attributes => [
                                           :id, :label, :position, :required, :_destroy])
  end

  def layout_options
    [
      {:id => "form-only", :name => "Form Only"},
      {:id => "right", :name => "Map Right"},
      {:id => "banner", :name => "Map Above"},
      {:id => "content", :name => "Description Right"},
      {:id => "inline", :name => "Description And Map"},
    ]
  end

end
