class Widgets::MercantileEmbedsController < Widgets::BaseController
  def index
    @mercantile_embed = MercantileEmbed.where(:uuid => params[:uuid]).first

    business_ids = []
    business_ids = @mercantile_embed.get_business_ids.compact #business_ids should be an array; returns array of Business ids, or empty array
    if @mercantile_embed.show_our_content == true
      business_ids << @mercantile_embed.business.id #includes parent business' content
    end

    @products = Product.where(business_id: business_ids.uniq).active.order('name asc').page(params[:page]).per(@mercantile_embed.max_items)
    # @products = get_content(
    #   business: @content_feed_widget.business,
    #   embed: @content_feed_widget,
    #   query: params[:blog_search],
    #   content_types: @content_types,
    #   content_category_ids: @content_feed_widget.content_category_ids,
    #   content_tag_ids: @content_feed_widget.content_tag_ids,
    #   order: 'desc',
    #   page: params[:page],
    #   per_page: @content_feed_widget.max_items
    # )

    # if @content_feed.blank?
    #   return false
    # end

    # if !params[:widget_layout].blank?
    #   @widget.layout = params[:widget_layout]
    # end
  end

  # def show
  #   @content_feed = ContentFeedWidget.where(:uuid => params[:uuid]).first
  #   if @content_feed.blank?
  #     return false
  #   end
  #   @page = @content_feed.business.owned_companies.find(params[:business_id])
  # end
end
