class Businesses::Content::FeedsController < Businesses::Content::BaseController
  include ContentSearchConcern

  def show
    if params[:unpublished]
      @results = get_content(business: @business, query: params[:query], content_types: (params[:post_types].present? ? params[:post_types] : ['QuickPost', 'Post', 'BeforeAfter', 'Gallery', 'Offer', 'Job']), content_category_ids: params[:categories], content_tag_ids: params[:tags], page: params[:page], per_page: 20, published: false)
    elsif params[:published]
      @results = get_content(business: @business, query: params[:query], content_types: (params[:post_types].present? ? params[:post_types] : ['QuickPost', 'Post', 'BeforeAfter', 'Gallery', 'Offer', 'Job']), content_category_ids: params[:categories], content_tag_ids: params[:tags], page: params[:page], per_page: 20, published: true)
    else
      @results = get_content(business: @business, query: params[:query], content_types: (params[:post_types].present? ? params[:post_types] : ['QuickPost', 'Post', 'BeforeAfter', 'Gallery', 'Offer', 'Job']), content_category_ids: params[:categories], content_tag_ids: params[:tags], page: params[:page], per_page: 20, published: '')
    end
    @categories = @business.content_categories
    @tags = @business.content_tags
    @post_types = %w(quick_post post before_after gallery offer job)
    @graph = FacebookAnalytics.new(facebook_token: @business.facebook_token)
  end
end
