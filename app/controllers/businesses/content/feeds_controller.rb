class Businesses::Content::FeedsController < Businesses::Content::BaseController
  def show
    binding.pry
    @results = ContentFeedSearch.new(@business, params[:unpublished], params[:query]).search.page(params[:page]).per(20).records
    binding.pry
  end
end
