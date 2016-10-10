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
    @gallery = Gallery.new(gallery_params)
    @gallery.business = @business
    @gallery.gallery_images.each do |image|
      image.gallery = @gallery
    end
    @gallery.save!
    if @business.facebook_id? && @business.facebook_token? && params[:facebook_publish]
      page_graph = Koala::Facebook::API.new(@business.facebook_token)
      result = page_graph.put_connections @business.facebook_id, 'feed', gallery_facebook_params
      @gallery.update_column :facebook_id, result['id']
    end
    if params[:draft]
       @gallery.published_status = false
       if @gallery.save
         redirect_to edit_business_content_gallery_path(@business, @gallery), alert: "Draft created successfully"
         # go straight to post edit page if saved as draft
         return
       end
    else
      @gallery.published_status = true
      redirect_to business_content_feed_path @business if @gallery.save
    end
    Gallery.__elasticsearch__.refresh_index!
    intercom_event 'created-gallery'
  end

  def edit
    port = ":#{request.try(:port)}" if request.port
    host = website_host @business.website
    post_path = website_gallery_path(@gallery)
    @preview_url = @gallery.published_status != false ? host + port + post_path : [:website, :generic_post, :preview, :type => "galleries", only_path: false, :host => website_host(@business.website), :id => @gallery.id]
  end

  def update
    @gallery.update(gallery_params)
    @gallery.generate_slug
    if @business.facebook_id? && @business.facebook_token? && params[:facebook_publish]
      page_graph = Koala::Facebook::API.new(@business.facebook_token)
      if @gallery.facebook_id?
        # Update Post
      else
        result = page_graph.put_connections @business.facebook_id, 'feed', gallery_facebook_params
        @gallery.update_column :facebook_id, result['id']
      end
    end
    if params[:draft]
       @gallery.published_status = false
       if @gallery.save
         redirect_to edit_business_content_gallery_path(@business, @gallery), notice: "Draft created successfully"
         # go straight to post edit page if saved as draft
         return
       end
    else
    @gallery.published_status = true
    redirect_to business_content_feed_path @business if @gallery.save
    end
    @gallery.__elasticsearch__.index_document
    Gallery.__elasticsearch__.refresh_index!
  end

  def destroy
    destroy_resource @gallery, location: [@business, :content_feed] do |success|
      if success
        begin
          if @business.facebook_id? && @business.facebook_token? && @gallery.facebook_id?
            page_graph = Koala::Facebook::API.new(@business.facebook_token)
            page_graph.delete_object @gallery.facebook_id
          end
        rescue
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
      :published_time,
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
      safe_params[:content_category_ids] = [] unless safe_params[:content_category_ids]
      safe_params[:content_tag_ids] = [] unless safe_params[:content_tag_ids]
    end
  end

  def gallery_facebook_params
    if @gallery.published_at > Time.now
      {
        caption: truncate(Sanitize.fragment(@gallery.description, Sanitize::Config::DEFAULT), length: 1000),
        link: url_for([:website, @gallery, only_path: false, host: website_host(@business.website)]),
        name: @gallery.title,
        picture: @gallery.gallery_images.first.try(:gallery_image).try(:attachment_url),
        published: false,
        scheduled_published_time: @gallery.published_at.to_i,
      }
    else
      {
        backdated_time: @gallery.published_at,
        caption: truncate(Sanitize.fragment(@gallery.description, Sanitize::Config::DEFAULT), length: 1000),
        link: url_for([:website, @gallery, only_path: false, host: website_host(@business.website)]),
        name: @gallery.title,
        picture: @gallery.gallery_images.first.try(:gallery_image).try(:attachment_url),
      }
    end
  end
end
