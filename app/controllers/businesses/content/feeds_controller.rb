class Businesses::Content::FeedsController < Businesses::Content::BaseController
  def show
    @results = ContentFeedSearch.new(@business, params[:unpublished], params[:published], 
    	params[:query]).search.page(params[:page]).per(20).records
    @graph = FacebookAnalytics.new(facebook_token: @business.facebook_token)
  end
end
