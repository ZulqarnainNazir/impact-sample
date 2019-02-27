class Businesses::Content::FeedsController < Businesses::Content::BaseController
  def show
    @results =
      Kaminari.paginate_array(
        ContentFeedSearch.new(
          @business,
          params[:unpublished],
          params[:published],
          params[:query],
          params[:post_types],
          content_category_ids: params[:categories],
          content_tag_ids: params[:tags]
        ).search
      ).page(params[:page]).per(20)

    @categories = @business.content_categories
    @tags = @business.content_tags
    # @post_types = @business.enabled_content_types #%w(event quick_post post before_after gallery offer job)
    @post_types = %w(event quick_post post before_after gallery offer job)
    @graph = FacebookAnalytics.new(facebook_token: @business.facebook_token)
  end
end
