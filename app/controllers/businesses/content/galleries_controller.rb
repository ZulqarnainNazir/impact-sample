class Businesses::Content::GalleriesController < Businesses::Content::BaseController
  include PlacementAttributesConcern
  include RequiresWebPlanConcern

  before_action only: new_actions do
    @gallery = @business.galleries.new
  end

  before_action only: member_actions do
    @gallery = @business.galleries.find(params[:id])
  end

  def create
    create_resource @gallery, gallery_params, location: [@business, :content_feed] do |success|
      if success
        if @business.facebook_id? && @business.facebook_token? && params[:facebook_publish]
          page_graph = Koala::Facebook::API.new(@business.facebook_token)
          result = page_graph.put_connections @business.facebook_id, 'feed', gallery_facebook_params
          @gallery.update_column :facebook_id, result['id']
        end
        Gallery.__elasticsearch__.refresh_index!
        intercom_event 'created-gallery'
      end
    end
  end

  def update
    update_resource @gallery, gallery_params, location: [@business, :content_feed] do |success|
      if success
        if @business.facebook_id? && @business.facebook_token? && params[:facebook_publish]
          page_graph = Koala::Facebook::API.new(@business.facebook_token)
          if @gallery.facebook_id?
            page_graph.put_connections @gallery.facebook_id, gallery_facebook_params
          else
            result = page_graph.put_connections @business.facebook_id, 'feed', gallery_facebook_params
            @gallery.update_column :facebook_id, result['id']
          end
        end
        Gallery.__elasticsearch__.refresh_index!
      end
    end
  end

  def destroy
    destroy_resource @gallery, location: [@business, :content_feed] do |success|
      if success
        if @business.facebook_id? && @business.facebook_token? && @gallery.facebook_id?
          page_graph = Koala::Facebook::API.new(@business.facebook_token)
          page_graph.delete_object @gallery.facebook_id
        end
        Gallery.__elasticsearch__.refresh_index!
      end
    end
  end

  private

  def gallery_params
    params.require(:gallery).permit(
      :description,
      :meta_description,
      :published_on,
      :title,
      content_category_ids: [],
      content_tag_ids: [],
      main_image_placement_attributes: placement_attributes,
      gallery_images_attributes: [
        :id,
        :_destroy,
        gallery_image_placement_attributes: placement_attributes,
      ],
    ).tap do |safe_params|
      merge_placement_image_attributes safe_params, :main_image_placement_attributes
      merge_placement_image_attributes_array safe_params[:gallery_images_attributes], :gallery_image_placement_attributes
      if safe_params[:gallery_images_attributes]
        safe_params[:gallery_images_attributes].each do |_, attr|
          attr.merge! gallery: @gallery
        end
      end
    end
  end

  def gallery_facebook_params
    if @gallery.published_at > Time.now
      {
        caption: Sanitize.fragment(@gallery.description, Sanitize::Config::DEFAULT),
        link: url_for([:website, @gallery, only_path: false, host: website_host(@business.website)]),
        name: @gallery.title,
        picture: @gallery.gallery_images.first.try(:gallery_image).try(:attachment_url),
        published: false,
        scheduled_published_time: @gallery.published_at.to_i,
      }
    else
      {
        backdated_time: @gallery.published_at,
        caption: Sanitize.fragment(@gallery.description, Sanitize::Config::DEFAULT),
        link: url_for([:website, @gallery, only_path: false, host: website_host(@business.website)]),
        name: @gallery.title,
        picture: @gallery.gallery_images.first.try(:gallery_image).try(:attachment_url),
      }
    end
  end
end
