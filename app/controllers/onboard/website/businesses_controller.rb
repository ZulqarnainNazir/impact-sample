class Onboard::Website::BusinessesController < Onboard::Website::BaseController
  before_action only: new_actions + %i[import] do
    @business = Business.new(owners: [current_user])
  end

  before_action only: member_actions do
    @business = current_user.businesses.find(params[:id])
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
    update_resource @business, business_params, location: [:edit_onboard_website, @business, :location]
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
      category_ids: [],
      logo_placement_attributes: [
        :id,
        :_destroy,
        image_attributes: [
          :id,
          :alt,
          :title,
          :attachment_cache_url,
          :attachment_content_type,
          :attachment_file_name,
          :attachment_file_size,
          :_destroy,
        ],
      ],
    ).deep_merge(
      logo_placement_attributes: {
        image_attributes: {
          user: current_user,
          business: @business,
        },
      },
    )
  end

  def facebook_params
    facebook_id = params[:facebook_id].split('/').last
    oauth = Koala::Facebook::OAuth.new(Rails.application.secrets.facebook_app_id, Rails.application.secrets.facebook_app_secret, nil)
    token = oauth.get_app_access_token
    graph = Koala::Facebook::API.new(token)
    page = graph.get_object(facebook_id).with_indifferent_access
    picture = graph.get_object("#{facebook_id}/picture").try(:with_indifferent_access)
    picture ||= graph.get_object("#{facebook_id}/photos").try(:[], 0)
    picture_url = picture['source']
    picture_name = File.basename(URI.parse(picture['source']).path) rescue nil
    {
      description: page[:description],
      name: page[:name],
      tagline: page[:about],
      website_url: page[:website],
      year_founded: page[:founded],
      facebook_id: facebook_id,
      logo_placement_attributes: {
        image_attributes: {
          attachment_cache_url: picture_url,
          attachment_file_name: picture_name,
          user: current_user,
          business: @business,
        },
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
        subdomain: ::Website.available_subdomain(page[:name]),
        header_block_attributes: {
          theme: 'inline',
          style: 'dark',
        },
        footer_block_attributes: {
          theme: 'simple',
        },
        home_page_attributes: {
          name: 'Homepage',
          title: page[:name],
          pathname: '',
          hero_block_attributes: {
            theme: 'left',
            heading: page[:name],
            text: page[:description],
            hero_block_image_placement_attributes: {
              image_attributes: {
                attachment_cache_url: page[:cover].try(:[], :source),
                user: current_user,
                business: @business,
              },
            },
          },
        },
      },
    }
  end
end
