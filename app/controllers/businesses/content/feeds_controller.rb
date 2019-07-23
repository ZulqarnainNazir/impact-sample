class Businesses::Content::FeedsController < Businesses::Content::BaseController
  include ContentSearchConcern

  def show
    @results = if params[:unpublished]
                 get_content(
                   business: @business,
                   query: params[:query],
                   content_types: content_types,
                   content_category_ids: content_category_ids,
                   content_tag_ids: content_tag_ids,
                   page: params[:page],
                   per_page: 20,
                   published: false
                 )
               elsif params[:published]
                 get_content(
                   business: @business,
                   query: params[:query],
                   content_types: content_types,
                   content_category_ids: content_category_ids,
                   content_tag_ids: content_tag_ids,
                   page: params[:page],
                   per_page: 20,
                   published: true
                 )
               else
                 get_content(
                   business: @business,
                   query: params[:query],
                   content_types: content_types,
                   content_category_ids: content_category_ids,
                   content_tag_ids: content_tag_ids,
                   page: params[:page],
                   per_page: 20,
                   published: ''
                 )
               end
    @categories = @business.content_categories
    @tags = @business.content_tags
    @post_types = ALL_CONTENT_TYPES
    @graph = FacebookAnalytics.new(facebook_token: @business.facebook_token)
  end

  private

  def content_types
    params[:post_types].present? ? params[:post_types].split : ALL_CONTENT_TYPES
  end

  def content_category_ids
    params[:categories].present? ? params[:categories].split : []
  end

  def content_tag_ids
    params[:tags].present? ? params[:tags].split : []
  end
end
