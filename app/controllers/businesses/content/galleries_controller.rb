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
    #@gallery.generate_slug
    @gallery.gallery_images.each do |image|
      image.gallery = @gallery
    end
    if params[:draft].present?
      @gallery.published_status = false
    else
      @gallery.published_status = true
    end
    respond_to do |format|
      if @gallery.save
        # flash[:appcues_event] = "Appcues.track('created gallery')"
        @gallery.__elasticsearch__.index_document
        flash[:notice] = 'Post was successfully created.'
        format.html { redirect_to edit_business_content_gallery_path(@business, @gallery), notice: "Draft created successfully" } if params[:draft].present?
        format.html { redirect_to edit_business_content_gallery_path(@business, @gallery), notice: "Post created successfully" } if !params[:draft].present?
      else
        flash[:notice] = 'Something went wrong - please try again.'
        format.html { render :action => "new" }
      end
    end
    #Gallery.__elasticsearch__.refresh_index!
    intercom_event 'created-gallery'
  end

  def edit
    port = ":#{request.try(:port)}" if request.port
    post_path = website_gallery_path(@gallery)
    @preview_url = @gallery.published_status != false ? @business.website.host + port + post_path : [:website, :generic_post, :preview, :type => "galleries", only_path: false, :host => @business.website.host, protocol: :http, :id => @gallery.id]
  end


  def update
    if params[:draft].present?
      @gallery.published_status = false
    else
      @gallery.published_status = true
    end
    respond_to do |format|

      if @gallery.update(gallery_params)
        #@gallery.generate_slug
        @gallery.__elasticsearch__.index_document
        flash[:notice] = 'Post updated.'
        format.html { redirect_to edit_business_content_gallery_path(@business, @gallery), notice: "Draft updated." } if params[:draft].present?
        format.html { redirect_to edit_business_content_gallery_path(@business, @gallery) } if !params[:draft].present?
      else
        flash[:notice] = 'Something went wrong - please try again.'
        format.html { render :action => "edit" }
      end
    end
    #Gallery.__elasticsearch__.refresh_index!
  end

  def destroy
    destroy_resource @gallery, location: [@business, :content_root] do |success|
      if success
        Gallery.__elasticsearch__.refresh_index!
      end
    end
  end

  def sharing_insights
    @gallery = Gallery.find(params[:gallery_id])
    @graph = FacebookAnalytics.new(facebook_token: @business.facebook_token)
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
end
