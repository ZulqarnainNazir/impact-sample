class Businesses::Crm::CompaniesController < Businesses::BaseController
  before_action only: new_actions do
    @company = @business.owned_companies.new
  end

  before_action only: member_actions do
    @company = @business.owned_companies.find(params[:id])
    @company.update_column :read_by, @company.read_by + [current_user.id] unless @company.read_by.include?(current_user.id)
  end

  def index
    scope = @business.owned_companies
    query = params[:query].to_s.strip

    if query.present?
      scope = scope.where('companies.name ILIKE ?', "%#{query}%")
    end

    @companies = scope.order(companies_order).page(params[:page]).per(20)
  end

  def create
    if params[:search_add] == 'true'
      @companies = Business.where("name ILIKE ?", "%#{params[:name]}%")
      if @companies.length < 1 or params[:force] == 'true'
        company = Company.create_with_associations(params, @business)
        redirect_to [:edit, @business, :crm, company, company.business]
      end
    elsif params[:add] == 'true'
      company = Company.where(:user_business_id => @business.id, :company_business_id => params[:new_business_id]).first
      if company.nil?
        new_business = Business.find(params[:new_business_id])
        company = Company.new(:user_business_id => @business.id, :company_business_id => new_business.id, :name => new_business.name,
                             :company_location_attributes => {:name => new_business.name})
        company.save
      end
      redirect_to [:edit, @business, :crm, company]
    end
  end

  def update
    company = Company.find(params[:id])
    if !params[:company][:business_attributes].nil? && !company.business.in_impact
      if company.update_attributes(company_business_params)
        #redirect_to [@business, :crm_companies]
        redirect_to [:edit, @business, :crm, company], :notice => "Successfully Saved Company"
      else
        render 'businesses/crm/business/edit'
      end
    else
      if company.update_attributes(company_params)
        redirect_to [@business, :crm_companies]
      else
        render 'edit'
      end
    end
  end

  def destroy
    Company.destroy(@company.id)
    redirect_to [@business, :crm_companies]
  end

  private

  def company_params
    params.require(:company).permit(
      :private_details, :name, :description, :website_url, :website_url, :facebook_id, :google_plus_id, :linkedin_id, 
      :twitter_id, :youtube_id, :citysearch_id, :instagram_id, :pinterest_id, :yelp_id, :foursquare_id, :zillow_id,
      :opentable_id, :trulia_id, :realtor_id, :tripadvisor_id, :houzz_id,
      crm_notes_attributes: [ :content, ],
      :company_list_ids => [],
      :company_location_attributes => [:name, :email, :street1, :street2, :city, :state, :zip_code, :phone_number]
    ).tap do |safe_params|
      if safe_params[:crm_notes_attributes]
        safe_params[:crm_notes_attributes].map do |_, attr|
          attr[:user_name] = current_user.name if attr[:content].present?
        end
      end
    end
  end
  def company_business_params
    params.require(:company).permit(:private_details, :business_attributes => [:name, :description, :website_url, 
      :website_url, :facebook_id, :google_plus_id, :linkedin_id, :twitter_id, :youtube_id, :citysearch_id, :instagram_id, 
      :pinterest_id, :yelp_id, :foursquare_id, :zillow_id, :opentable_id, :trulia_id, :realtor_id, :tripadvisor_id, :houzz_id,
      :location_attributes => [:name, :email, :street1, :street2, :city, :state, :zip_code, :phone_number]])
  end

  def business_update_params
    params[:company].require(:business_attributes).permit(:name, :description, :website_url)
  end

  def business_location_update_params
    params[:company][:business_attributes].require(:location_attributes).permit(:name, :email, :street1, :street2, :city, :state, :zip_code, :phone_number)
  end

  def companies_order
    if %w[name email phone_number].include?(params[:order_by])
      "#{params[:order_by]} #{companies_order_dir} NULLS LAST"
    else
      'CASE WHEN cardinality(read_by) = 0 THEN 0 ELSE 1 END ASC, updated_at DESC'
    end
  end

  def companies_order_dir
    if %w[asc desc].include?(params[:order_dir])
      params[:order_dir]
    else
      'desc'
    end
  end
end
