class Onboard::Website::BusinessesController < Onboard::Website::BaseController
  include PlacementAttributesConcern

  before_action only: new_actions + %i[import] do
    @business = Business.new
    @business.owners = [current_user] unless current_user.super_user?
  end

  before_action only: member_actions do
    @business = current_user.authorized_businesses.find(params[:id])
  end

  before_action only: %i[create update] do
    params[:business][:category_ids].reject!(&:blank?) rescue nil
  end

  def create
    create_resource @business, initial_business_params, context: :onboard_website, location: [:edit_onboard_website, @business]
  end

  def import
    begin
      create_resource @business, facebook_params, context: :onboard_website, location: [:edit_onboard_website, @business] do |success|
        FacebookPhotosImportJob.perform_later(@business, current_user) if success
      end
    rescue
      redirect_to :new_onboard_website_business, alert: 'Sorry, it looks like that page is missing or has a privacy setting that prevents us from importing data.'
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
    ).deep_merge(
      plan: :primary,
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
      plan: :primary,
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
        name: page[:location].try(:[], :name),
        street1: page[:location].try(:[], :street),
        city: page[:location].try(:[], :city),
        state: page[:location].try(:[], :state),
        zip_code: page[:location].try(:[], :zip),
        latitude: page[:location].try(:[], :latitude),
        longitude: page[:location].try(:[], :longitude),
        phone_number: page[:phone],
      },
      website_attributes: {
        home_page_attributes: {
          active: true,
          name: 'Homepage',
          title: page[:name],
          pathname: '',
          hero_block_attributes: {
            heading: page[:name],
            text: page[:description],
            hero_block_image_placement_attributes: {
              image_attachment_cache_url: page[:cover].try(:[], :source),
              image_user: current_user,
              image_business: @business,
            },
          },
        },
      },
    }
  end
end
