class Businesses::Content::FeedsController < Businesses::Content::BaseController
  def show
    @results = 
    	Kaminari.paginate_array(
		    ContentFeedSearch.new(
		    	@business, 
		    	params[:unpublished], 
		    	params[:published], 
		    	params[:query]
		    ).search
		).page(params[:page]).per(20)

    @graph = FacebookAnalytics.new(facebook_token: @business.facebook_token)
  end
end
