class Widgets::CalendarWidgetsController < Widgets::BaseController
  def index
    @calendar_widget = CalendarWidget.where(:uuid => params[:uuid]).first
    @business = @calendar_widget.business
    # get_content_types(nil, @calendar_widget)

    if @content_feed.blank?
      return false
    end

    if !params[:widget_layout].blank?
      @widget.layout = params[:widget_layout]
    end
  end
  def show
    @calendar_widget = CalendarWidget.where(:uuid => params[:uuid]).first
    if @calendar_widget.blank?
      return false
    end
    @page = @calendar_widget.business.owned_companies.find(params[:business_id])
  end
end
