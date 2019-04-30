class Widgets::ContentFeedWidgetsController < Widgets::BaseController
  def index
    @content_feed_widget = ContentFeedWidget.where(:uuid => params[:uuid]).first
    @business = @content_feed_widget.business

    if params[:content_types]
        @content_types = params[:content_types]
    elsif @content_feed_widget.content_types.present?
      # TODO - Below returns wrong types so should update source to pass correct types (remove event, change custompost to post) so don't need the delete and add functions
      @content_types = @content_feed_widget.content_types.join(" ").split
      @content_types.delete('Event')
      @content_types.delete('CustomPost')
      @content_types << 'Post'
    else
      @content_types = "QuickPost Offer Job Gallery BeforeAfter Post".split
    end

    @content_types_all = "QuickPost Offer Job Gallery BeforeAfter Post".split

    @posts = get_content(business: @business, embed: @content_feed_widget, query: params[:blog_search], content_types: @content_types, content_category_ids: @content_feed_widget.content_category_ids, content_tag_ids: @content_feed_widget.content_tag_ids, order: 'desc', page: params[:page], per_page: @content_feed_widget.max_items)

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
