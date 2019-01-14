#NOTE: This controller pulls businesses from the business model, NOT the business
#model. The Business model contains records for firms that have accounts on IMPACT.
class Super::BusinessDataController < SuperController
  before_action :set_business, except: [:index]
  layout 'businesses'

  def index #index of master copies of firms
  	#business table holds core business data for all firms, including those that have
  	#records in the Business table (firms with records in Business table are those that
  		# have accounts on IMPACT, i.e., have active websites)
    @businesses = Business.order("id").search(params[:search]) #.page(params[:page]).per(20)
  end

  def edit
  	@location = @business.location
  end

  def update
  	if @business.update_attributes(business_and_related_params)
  		flash[:notice] = "You've updated data on this business."
  		redirect_to edit_super_business_datum_path(@business)
  	else
          Rails.logger.info(@business.errors.messages.inspect)
  		flash[:notice] = "Update error. Please try again."
  		render 'edit'
  	end
  end


  def merge_with
  	#merge_with, a GET resource, is where the super admin can search for and
  	#select a business to merge into the parent business; merge_with is a member
  	#of a business reflected in the route.
  	@businesses = Business.order("id").merge_search(params[:search], @business).page(params[:page]).per(20)
  end

  def select_merge_fields
  	@businesses = []
  	params[:businesses].each do |n|
  		@businesses << Business.find(n.to_i)
  	end
  end

  def merge_now
  	#takes if there is an empty field the parent business, and that field
  	#is not empty in the selected business, merge the latter into the former
  	#once this process is finished for ALL fields, delete the selected business
  	#and make sure all Company entries that pointed to selected business
  	#now point to parent business.
	if @business.update_attributes(business_and_related_params)
		@business.merge_crm_relations(params[:businesses])
		flash[:notice] = "You've updated data on this business."
		redirect_to edit_super_business_datum_path(@business)

	else
        Rails.logger.info(@business.errors.messages.inspect)
		flash[:notice] = "Update error. Please try again."
		render 'edit'
	end
  end


  private

	def set_business
		@business = Business.find(params[:id])
	end

	def business_and_related_params
	    params.require(:business).permit(:name, :description, :website_url,
	      :website_url, :facebook_id, :google_plus_id, :linkedin_id, :twitter_id, :youtube_id, :citysearch_id, :instagram_id, :pinterest_id, :yelp_id, :kind, :foursquare_id, :zillow_id, :opentable_id, :trulia_id, :realtor_id, :tripadvisor_id, :houzz_id, :year_founded, community_ids: [],
	      :location_attributes => [:name, :email, :street1, :street2, :city, :state, :zip_code, :phone_number],
          :logo_placement_attributes => [:id, :kind, :_destroy, :image_id, :image_attachment_cache_url, :image_attachment_content_type, :image_attachment_file_name, :image_attachment_file_size, :image_alt, :image_title]
		).deep_merge(
          logo_placement_attributes: {
            image_user: current_user,
            image_business: @business,
          },
        )
	end

	def just_business_params
		params.require(:business).permit(
			:name,
			:tagline,
			:private_details,
			:description,
			:hide,
			:website_url,
			:facebook_id,
			:google_plus_id,
			:linkedin_id,
			:twitter_id,
			:youtube_id,
			:citysearch_id,
			:instagram_id,
			:pinterest_id,
			:yelp_id,
			:foursquare_id,
			:zillow_id,
			:trulia_id,
			:realtor_id,
			:tripadvisor_id,
			:houzz_id,
      community_ids: []
		)
	end

end
