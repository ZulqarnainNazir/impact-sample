class Onboard::BusinessesController < ApplicationController
  include PlacementAttributesConcern

  before_action only: new_actions + %i[import_cce import_facebook] do
    params[:business][:category_ids] = category_ids
    @business = Business.new
    @business.plan = :free
    @business.authorizations.build(role: 0, user: current_user)
  end

  before_action only: member_actions do
    params[:business][:category_ids] = category_ids
    @business = Business.find(params[:business][:id])
    if @business.owners.length > 0 && @business.owners.first != current_user
      render json: { errors: "Forbidden: Business already has an owner", status: 403}
    elsif @business.owners.length == 0
      @business.authorizations.build(role: 0, user: current_user)
    end
  end

  def build_subscription
    @subscription = @business.build_subscription
    @subscription.plan = SubscriptionPlan.engage_plan
    @subscription.state = 'active'
    @subscription.subscriber = @business
    unless cookies[:affiliate_token].nil?
      @affiliate = SubscriptionAffiliate.find_by(token: cookies[:affiliate_token])
      unless !@affiliate.business.affiliate_activated?
        @subscription.affiliate = @affiliate
      end
    end
    @subscription.save!
  end

  def create
    @business.assign_attributes(initial_business_params)
    @business.attributes.merge(business_params)
    @business.build_location(business_location_params.merge(name: initial_business_params[:name]))
    @business.build_website ({
      subdomain: Subdomain.available(initial_business_params[:name]),
      header_block_attributes: {},
      footer_block_attributes: {},
    })
    if @business.save!
      build_subscription
      @business.create_default_directories
    end
    render :show
  end

  def update
    build_subscription
    unless @business.website
      @business.website_attributes = {
        subdomain: Subdomain.available(initial_business_params[:name]),
        header_block_attributes: {},
        footer_block_attributes: {},
      }
    end
    @business.in_impact = true
    @business.update!(business_params)
    @business.location.update(business_location_params)
    if current_user.super_user? && @business.company_lists.blank?
      @business.create_default_directories
    end
    render :show
  end

  private

  def initial_business_params
    params.require(:business).permit(
      :name,
    )
  end

  def business_params
    params.require(:business).permit(
      :name,
      :description,
      :kind,
      :name,
      :tagline,
      :membership_org,
      :website_url,
      :year_founded,
      :cce_url,
      :citysearch_id,
      :facebook_id,
      :foursquare_id,
      :google_plus_id,
      :houzz_id,
      :instagram_id,
      :linkedin_id,
      :opentable_id,
      :pinterest_id,
      :realtor_id,
      :tripadvisor_id,
      :trulia_id,
      :twitter_id,
      :yelp_id,
      :youtube_id,
      :zillow_id,
      category_ids: [],
      location: [],
      categories: [],
      logo_placement_attributes: placement_attributes,
    ).deep_merge(
      logo_placement_attributes: {
        image_user: current_user,
        image_business: @business,
      },
    )
  end

  def business_location_params
    params.require(:business).require(:location).permit(
      :name,
      :email,
      :phone_number,
      :street1,
      :street2,
      :city,
      :state,
      :zip_code,
      :hide_address,
      :hide_email,
      :hide_phone,
      :external_service_area,
      :service_area,
      openings_attributes: [
        :id,
        :opens_at,
        :closes_at,
        :sunday,
        :monday,
        :tuesday,
        :wednesday,
        :thursday,
        :friday,
        :saturday,
        :_destroy,
      ]
    )
  end

  def category_ids
    params[:business][:categories].map { |e| e[1][:id].to_i }
  end
end
