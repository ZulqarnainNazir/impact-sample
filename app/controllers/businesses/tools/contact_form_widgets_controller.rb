class Businesses::Tools::ContactFormWidgetsController < Businesses::BaseController

  before_action only: member_actions do
    @contact_form_widget = @business.contact_form_widgets.find(params[:id])
  end

  def new
    @contact_form_widget = @business.contact_form_widgets.new
  end

  def index
    scope = @business.contact_form_widgets
    query = params[:query].to_s.strip

    if query.present?
      scope = scope.where('name ILIKE ?', "%#{query}%")
    end

    @contact_form_widgets = scope.page(params[:page]).per(20)
  end

  def create
    @contact_form_widget = @business.contact_form_widgets.new
    create_resource @contact_form_widget, contact_form_widget_params, location: [:edit, @business, :tools, @contact_form_widget]
  end

  def update
    contact_form_widget = @business.contact_form_widgets.find(params[:id])
    if contact_form_widget.update_attributes(contact_form_widget_params)
      redirect_to [:edit, @business, :tools, @contact_form_widget], :flash => { :notice => "Widget Saved Successfully" }
    else
      render 'edit'
    end
  end

  def destroy
    Widget.destroy(@contact_form_widget.id)
    redirect_to [@business, :tools_contact_form_widgets]
  end

  private

  def contact_form_widget_params
    params.require(:contact_form_widget).permit(:name, :public_label, :contact_form_id)
  end

end
