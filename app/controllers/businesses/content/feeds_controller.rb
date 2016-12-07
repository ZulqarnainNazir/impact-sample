class Businesses::Content::FeedsController < Businesses::Content::BaseController
  def show
    @results = ContentFeedSearch.new(@business, params[:unpublished], params[:published], 
    	params[:query]).search.page(params[:page]).per(20).records

  end
end
