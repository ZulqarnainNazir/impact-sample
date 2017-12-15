class Businesses::Tools::CalendarWidgetsController < Businesses::BaseController

  before_action only: member_actions do
    @calendar_widget = @business.calendar_widgets.find(params[:id])
  end

  def new
    @calendar_widget = @business.calendar_widgets.new
  end

  def index
    scope = @business.calendar_widgets
    query = params[:query].to_s.strip

    if query.present?
      scope = scope.where('name ILIKE ?', "%#{query}%")
    end

    @calendar_widgets = scope.page(params[:page]).per(20)
  end

  def create
    @calendar_widget = @business.calendar_widgets.new
    create_resource @calendar_widget, calendar_widget_params, location: [:edit, @business, :tools, @calendar_widget]
  end

  def update
    calendar_widget = @business.calendar_widgets.find(params[:id])
    if calendar_widget.update_attributes(calendar_widget_params)
      redirect_to [:edit, @business, :tools, @calendar_widget], :flash => { :notice => "Widget Saved Successfully" }
    else
      render 'edit'
    end
  end

  def destroy
    CalendarWidget.destroy(@calendar_widget.id)
    redirect_to [@business, :tools_calendar_widgets]
  end

  private

  def calendar_widget_params
    params.require(:calendar_widget).permit(:name, :public_label, :default_view, :max_items, :enable_search, :show_our_content, :company_list_ids => [])
  end

end
