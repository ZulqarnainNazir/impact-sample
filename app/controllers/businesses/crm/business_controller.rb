class Businesses::Crm::BusinessController < Businesses::BaseController
  def edit
    @company = Company.find(params[:company_id])
    @business = Business.find(params[:business_id])
  end
#  def update
#    company = Company.find(params[:company_id])
#    @business = Business.find(params[:business_id])
#    if company.update(company_business_params)
#      redirect_to [@business, :crm_companies]
#    else
#      render 'business_edit'
#    end
#  end

  private

  def company_business_params
    params.require(:company).permit(:private_details, :business_attributes => [:name, :description, :website_url, 
      :website_url, :facebook_id, :google_plus_id, :linkedin_id, :twitter_id, :youtube_id, :citysearch_id, :instagram_id, 
      :pinterest_id, :yelp_id, :foursquare_id, :zillow_id, :opentable_id, :trulia_id, :realtor_id, :tripadvisor_id, :houzz_id],
      :location_attributes => [:name, :email, :street1, :street2, :city, :state, :zip_code, :phone_number])
  end
end
