class Widgets::MercantileEmbedsController < Widgets::BaseController
  def index
    @mercantile_embed = MercantileEmbed.where(:uuid => params[:uuid]).first
    if @mercantile_embed.present?

      @filtered_categories = @categories = @mercantile_embed.company_list.company_list_categories
      unless params[:category].blank?
        @filtered_categories = @filtered_categories.where("company_list_categories.id = ?", params[:category])
      end

      business_ids =[]
      business_ids << CompanyList.where(id: @mercantile_embed.company_list_id).includes(:companies).pluck('companies.company_business_id').compact if @mercantile_embed.company_list_id.present?
      business_ids << @mercantile_embed.business.id if @mercantile_embed.show_our_content

      scope = Product.where(business_id: business_ids.uniq).where("products.product_kind IN (?)", @mercantile_embed.product_kinds.reject(&:blank?)).joins(:business).where.not(businesses: {stripe_connected_account_id: nil }).active.order('products.name asc')
      # For Testing without Stripe connection
      # scope = Product.where(business_id: business_ids.uniq).joins(:business).active.order('products.name asc')

      @merchants = Business.where(id: scope.pluck(:business_id)).select(:id, :name)
      @product_kinds = Product.product_kinds.map { |k,v| [k.humanize.titleize, v] if @mercantile_embed.product_kinds.reject(&:blank?).include?(v.to_s) }.compact

      unless params[:product_kind].blank?
        scope = scope.where("products.product_kind = ?", params[:product_kind])
      end

      unless params[:query].blank?
        scope = scope.where("products.name ILIKE ?", "%#{params[:query].downcase}%")
      end

      unless params[:merchant].blank?
        scope = scope.where("products.business_id = ?", params[:merchant])
      end

      if @mercantile_embed.company_list.sort_by == 0
        scope = scope.page(params[:product_page]).per(@mercantile_embed.max_items)
      end

      @products = scope

    end


    # business_ids = []
    # business_ids = @mercantile_embed.get_business_ids.compact #business_ids should be an array; returns array of Business ids, or empty array
    # if @mercantile_embed.show_our_content == true
    #   business_ids << @mercantile_embed.business.id #includes parent business' content
    # end
    #
    # @products = Product.where(business_id: business_ids.uniq).active.order('name asc').page(params[:page]).per(@mercantile_embed.max_items)
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
