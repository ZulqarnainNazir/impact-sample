class Onboard::Website::BusinessesController < Onboard::Website::BaseController
  include PlacementAttributesConcern

  before_action only: new_actions + %i[import_cce import_facebook] do
    @business = Business.new

    if current_user.super_user?
      @business.plan = :primary
    else
      @business.plan = :free
      @business.authorizations.build(role: 0, user: current_user)
    end
  end

  before_action only: member_actions do
    @business = current_user.authorized_businesses.find(params[:id])
  end

  before_action only: %i[create update] do
    params[:business][:category_ids].reject!(&:blank?) rescue nil
  end

  layout :select_layout

  def select_layout
    %w[new create].include?(action_name) ? 'application' : 'onboard_website'
  end

  def create
    @business.location_attributes= { name: initial_business_params[:name] }
    @business.website_attributes = {
      subdomain: Subdomain.available(initial_business_params[:name]),
      header_block_attributes: {},
      footer_block_attributes: {},
    }
    create_resource @business, initial_business_params, location: [:edit_onboard_website, @business]
  end

  def import_cce
      locable_business = LocableBusiness.find_by_slug(params[:cce_business_url].to_s.split('/').last)

      if locable_business
        existing_user_cce_business = current_user.businesses.where(cce_id: locable_business.id).first
        existing_global_cce_business = Business.where(cce_id: locable_business.id).first

        if existing_user_cce_business
          redirect_to([existing_user_cce_business, :dashboard])
        elsif existing_global_cce_business && current_user.super_user?
          redirect_to([existing_global_cce_business, :dashboard])
        elsif existing_global_cce_business
          redirect_to([:new_onboard_website_business, cce_business_url: params[:cce_business_url]], alert: 'Sorry, it looks like that business has already been claimed.')
        else
          create_resource @business, cce_params(locable_business), location: [:edit_onboard_website, @business] do |success|
            if success
              if locable_business.claimed?
                locable_business.link(@business)
              else
                locable_business.claim(@business, current_user)
              end
            end
          end
        end
      else
        redirect_to [:new_onboard_website_business, cce_business_url: params[:cce_business_url]], alert: 'Sorry, it looks like that page is missing or has a privacy setting that prevents us from importing data.'
    end
  end

  def import_facebook
    begin
      create_resource @business, facebook_params, location: [:edit_onboard_website, @business] do |success|
        FacebookPhotosImportJob.perform_later(@business, current_user) if success
      end
    rescue
      redirect_to [:new_onboard_website_business, facebook_id: params[:facebook_id]], alert: 'Sorry, it looks like that page is missing or has a privacy setting that prevents us from importing data.'
    end
  end

  def update
    update_resource @business, business_params, context: :requires_categories, location: [:edit_onboard_website, @business, :location]
  end

  def destroy
    @business.destroy!
    redirect_to :new_onboard_website_business, notice: 'Ok, we’ve removed your business.'
  end

  private

  def initial_business_params
    params.require(:business).permit(
      :name,
    )
  end

  def business_params
    params.require(:business).permit(
      :description,
      :kind,
      :name,
      :tagline,
      :website_url,
      :year_founded,
      :cce_url,
      :citysearch_id,
      :facebook_id,
      :google_plus_id,
      :instagram_id,
      :linkedin_id,
      :pinterest_id,
      :twitter_id,
      :yelp_id,
      :youtube_id,
      category_ids: [],
      logo_placement_attributes: placement_attributes,
    ).deep_merge(
      logo_placement_attributes: {
        image_user: current_user,
        image_business: @business,
      },
    )
  end

  def cce_params(locable_business)
    openings_attributes = []

    locable_business.business_hours.each do |business_hour|
      opening = openings_attributes.find do |o|
        o[:opens_at] == Time.at(Time.parse(business_hour.open).to_i + Time.parse(business_hour.open).utc_offset) &&
        o[:closes_at] == Time.at(Time.parse(business_hour.close).to_i + Time.parse(business_hour.close).utc_offset)
      end

      if opening
        opening[business_hour.day.downcase] = true
      else
        openings_attributes.push({
          opens_at: Time.at(Time.parse(business_hour.open).to_i + Time.parse(business_hour.open).utc_offset),
          closes_at: Time.at(Time.parse(business_hour.close).to_i + Time.parse(business_hour.close).utc_offset),
          business_hour.day.downcase => true,
        })
      end
    end

    {
      cce_id: locable_business.id,
      cce_url: locable_business.locable_url,
      name: locable_business.name,
      description: locable_business.description,
      tagline: locable_business.tagline,
      website_url: locable_business.url,
      category_ids: Category.where(name: locable_business.categories.pluck(:name)).pluck(:id),
      facebook_id: locable_business.business_social_media_properties.where(property_type: 0).first.try(:value).to_s.split('/').last,
      twitter_id: locable_business.business_social_media_properties.where(property_type: 1).first.try(:value).to_s.split('/').last,
      linkedin_id: locable_business.business_social_media_properties.where(property_type: 'linkedin_url').first.try(:value).to_s.split('/').last,
      pinterest_id: locable_business.business_social_media_properties.where(property_type: 2).first.try(:value).to_s.split('/').last,
      instagram_id: locable_business.business_social_media_properties.where(property_type: 3).first.try(:value).to_s.split('/').last,
      google_plus_id: locable_business.business_social_media_properties.where(property_type: 4).first.try(:value).to_s.split('/').last,
      youtube_id: locable_business.business_social_media_properties.where(property_type: 5).first.try(:value).to_s.split('/').last,
      logo_placement_attributes: {
        image_attachment_cache_url: locable_business.logo.try(:file_url),
        image_attachment_content_type: locable_business.logo.try(:mime),
        image_attachment_file_name: locable_business.logo.try(:file),
        image_attachment_file_size: locable_business.logo.try(:size),
        image_alt: locable_business.logo.try(:caption),
        image_user: current_user,
        image_business: @business,
      },
      location_attributes: {
        name: locable_business.name,
        street1: locable_business.address.try(:street1),
        street2: locable_business.address.try(:street2),
        city: locable_business.address.try(:city),
        state: locable_business.address.try(:state),
        zip_code: locable_business.address.try(:postal),
        email: locable_business.email,
        phone_number: locable_business.phone,
        openings_attributes: openings_attributes,
      },
      website_attributes: {
        subdomain: Subdomain.available(locable_business.name),
        header_block_attributes: {},
        footer_block_attributes: {},
        webpages_attributes: [
          {
            type: 'HomePage',
            active: true,
            name: 'Homepage',
            title: locable_business.name,
            pathname: '',
            groups_attributes: [
              {
                type: 'HeroGroup',
                blocks_attributes: [
                  {
                    type: 'HeroBlock',
                    heading: locable_business.name,
                    text: locable_business.description,
                    block_background_placement_attributes: {
                      image_attachment_cache_url: locable_business.images.first.try(:file_url),
                      image_attachment_content_type: locable_business.images.first.try(:mime),
                      image_attachment_file_name: locable_business.images.first.try(:file),
                      image_attachment_file_size: locable_business.images.first.try(:size),
                      image_alt: locable_business.images.first.try(:caption),
                      image_user: current_user,
                      image_business: @business,
                    },
                  },
                ],
              },
            ],
          },
        ],
      },
    }
  end

  def facebook_params
    facebook_id = params[:facebook_id].to_s.split('/').last.split('?').first
    oauth = Koala::Facebook::OAuth.new(Rails.application.secrets.facebook_app_id, Rails.application.secrets.facebook_app_secret, nil)
    token = oauth.get_app_access_token
    graph = Koala::Facebook::API.new(token)
    page = graph.get_object(facebook_id).with_indifferent_access
    picture = graph.get_object("#{facebook_id}/picture").try(:with_indifferent_access)
    picture ||= graph.get_object("#{facebook_id}/photos").try(:[], 0)
    picture_url = picture['source']
    picture_name = File.basename(URI.parse(picture['source']).path) rescue nil
    {
      name: page[:name],
      description: page[:description],
      tagline: page[:about],
      website_url: page[:website],
      year_founded: page[:founded],
      facebook_id: facebook_id,
      logo_placement_attributes: {
        image_attachment_cache_url: picture_url,
        image_attachment_file_name: picture_name,
        image_user: current_user,
        image_business: @business,
      },
      location_attributes: {
        name: page[:location].try(:[], :name) || page[:name],
        street1: page[:location].try(:[], :street),
        city: page[:location].try(:[], :city),
        state: page[:location].try(:[], :state),
        zip_code: page[:location].try(:[], :zip),
        latitude: page[:location].try(:[], :latitude),
        longitude: page[:location].try(:[], :longitude),
        phone_number: page[:phone],
      },
      website_attributes: {
        subdomain: Subdomain.available(page[:name]),
        header_block_attributes: {},
        footer_block_attributes: {},
        webpages_attributes: [
          {
            type: 'HomePage',
            active: true,
            name: 'Homepage',
            title: page[:name],
            pathname: '',
            groups_attributes: [
              {
                type: 'HeroGroup',
                blocks_attributes: [
                  {
                    type: 'HeroBlock',
                    heading: page[:name],
                    text: page[:description],
                    block_background_placement_attributes: {
                      image_attachment_cache_url: page[:cover].try(:[], :source),
                      image_user: current_user,
                      image_business: @business,
                    },
                  },
                ],
              },
            ],
          },
        ],
      },
    }
  end
end
