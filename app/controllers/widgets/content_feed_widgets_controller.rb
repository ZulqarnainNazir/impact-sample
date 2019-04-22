class Widgets::ContentFeedWidgetsController < Widgets::BaseController
  def index
    @content_feed_widget = ContentFeedWidget.where(:uuid => params[:uuid]).first
    @business = @content_feed_widget.business
    # get_content_types(nil, @content_feed_widget)

    if @content_feed.blank?
      return false
    end

    if !params[:widget_layout].blank?
      @widget.layout = params[:widget_layout]
    end
  end
  def show
    @content_feed = ContentFeedWidget.where(:uuid => params[:uuid]).first
    if @content_feed.blank?
      return false
    end
    @page = @content_feed.business.owned_companies.find(params[:business_id])
  end
end
