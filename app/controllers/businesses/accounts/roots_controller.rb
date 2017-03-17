class Businesses::Accounts::RootsController < Businesses::BaseController

	def show
	  @business = Business.find(params[:business_id])
	  @linked_facebook_page =  @business.facebook_id? && @business.facebook_token?
	  @locable_business =  @business.cce_id?
	end
end
