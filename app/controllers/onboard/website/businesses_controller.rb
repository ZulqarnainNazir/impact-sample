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
    begin
      create_resource @business, cce_params, location: [:edit_onboard_website, @business]
    rescue
      redirect_to [:new_onboard_website_business, cce_business_url: params[:cce_business_url]], alert: 'Sorry, it looks like that page is missing.'
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

  def cce_params
    business_slug = params[:cce_business_url].to_s.split('/').last.split('?').first
    payload = connect_to("/businesses/#{business_slug}", email: current_user.email)
    cover_image = payload[:images].try(:[], 0)
    category_ids = Category.where(name: Array(payload[:business_categories]).map { |c| c[:name] }).pluck(:id)
    openings_attributes = []

    Array(payload[:business_hours]).each do |business_hour|
      opening = openings_attributes.find do |o|
        o[:opens_at] == Time.at(Time.parse(business_hour[:open]).to_i + Time.parse(business_hour[:open]).utc_offset) &&
        o[:closes_at] == Time.at(Time.parse(business_hour[:close]).to_i + Time.parse(business_hour[:close]).utc_offset)
      end

      if opening
        opening[business_hour[:day].to_s.downcase] = true
      else
        openings_attributes.push({
          opens_at: Time.at(Time.parse(business_hour[:open]).to_i + Time.parse(business_hour[:open]).utc_offset),
          closes_at: Time.at(Time.parse(business_hour[:close]).to_i + Time.parse(business_hour[:close]).utc_offset),
          business_hour[:day].to_s.downcase => true,
        })
      end
    end

    {
      cce_id: payload[:id],
      name: payload[:name],
      description: payload[:description],
      tagline: payload[:tagline],
      category_ids: category_ids,
      cce_url: payload[:website_url],
      facebook_id: Array(payload[:business_social_media_properties]).find { |p| p[:property_type].to_s == 'facebook_url' }.try(:[], :value).try(:split, '/').try(:last),
      google_plus_id: Array(payload[:business_social_media_properties]).find { |p| p[:property_type].to_s == 'google_plus_url' }.try(:[], :value).try(:split, '/').try(:last),
      twitter_id: Array(payload[:business_social_media_properties]).find { |p| p[:property_type].to_s == 'twitter_url' }.try(:[], :value).try(:split, '/').try(:last),
      linkedin_id: Array(payload[:business_social_media_properties]).find { |p| p[:property_type].to_s == 'linkedin_url' }.try(:[], :value).try(:split, '/').try(:last),
      pinterest_id: Array(payload[:business_social_media_properties]).find { |p| p[:property_type].to_s == 'pinterest_url' }.try(:[], :value).try(:split, '/').try(:last),
      instagram_id: Array(payload[:business_social_media_properties]).find { |p| p[:property_type].to_s == 'instagram_url' }.try(:[], :value).try(:split, '/').try(:last),
      youtube_id: Array(payload[:business_social_media_properties]).find { |p| p[:property_type].to_s == 'youtube_url' }.try(:[], :value).try(:split, '/').try(:last),
      logo_placement_attributes: {
        image_attachment_cache_url: payload[:logo].try(:[], :file_url),
        image_attachment_content_type: payload[:logo].try(:[], :mime),
        image_attachment_file_name: payload[:logo].try(:[], :filename),
        image_attachment_file_size: payload[:logo].try(:[], :size),
        image_alt: payload[:logo].try(:[], :caption),
        image_user: current_user,
        image_business: @business,
      },
      location_attributes: {
        name: payload[:name],
        street1: payload[:address].try(:[], :street1),
        street2: payload[:address].try(:[], :street2),
        city: payload[:address].try(:[], :city),
        state: payload[:address].try(:[], :state),
        zip_code: payload[:address].try(:[], :postal),
        email: payload[:email],
        phone_number: payload[:phone],
        openings_attributes: openings_attributes,
      },
      website_attributes: {
        subdomain: Subdomain.available(payload[:name]),
        header_block_attributes: {},
        footer_block_attributes: {},
        webpages_attributes: [
          {
            type: 'HomePage',
            active: true,
            name: 'Homepage',
            title: payload[:name],
            pathname: '',
            groups_attributes: [
              {
                type: 'HeroGroup',
                blocks_attributes: [
                  {
                    type: 'HeroBlock',
                    heading: payload[:name],
                    text: payload[:description],
                    block_background_placement_attributes: {
                      image_attachment_cache_url: cover_image.try(:[], :file_url),
                      image_attachment_content_type: cover_image.try(:[], :mime),
                      image_attachment_file_name: cover_image.try(:[], :filename),
                      image_attachment_file_size: cover_image.try(:[], :size),
                      image_alt: cover_image.try(:[], :caption),
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
