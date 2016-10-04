class Businesses::Content::FeedsController < Businesses::Content::BaseController
  def show
    drafts = params[:draft_items].present?
    published = params[:published_items].present?

    filters = {drafts:drafts, published:published}
    @results = ContentFeedSearch.new(@business, params[:query], filters).search.page(params[:page]).per(20).records

  end
end
