class Businesses::Content::BeforeAftersController < Businesses::Content::BaseController
  include PlacementAttributesConcern
  include RequiresWebPlanConcern

  before_action only: new_actions do
    @before_after = @business.before_afters.new
  end

  before_action only: member_actions do
    @before_after = @business.before_afters.find(params[:id])
  end

  def create
    @before_after = BeforeAfter.new(before_after_params)
    @before_after.business = @business
    if @business.facebook_id? && @business.facebook_token? && params[:facebook_publish] && @before_after.published_on < DateTime.now
      page_graph = Koala::Facebook::API.new(@business.facebook_token)
      result = page_graph.put_connections @business.facebook_id, 'feed', before_after_facebook_params
      @before_after.update_column :facebook_id, result['id']
    end
    if params[:draft]
      @before_after.published_status = false
    else
      @before_after.published_status = true
    end

    respond_to do |format|
      if @before_after.save
        format.html { redirect_to edit_business_content_before_after_path(@business, @before_after), notice: "Draft created successfully" } if params[:draft] 
        format.html { redirect_to business_content_feed_path @business, notice: "Post created successfully" } if !params[:draft]
      else
        format.html { redirect_to new_business_content_before_after_path, :alert => "Post must have a title" }
      end
    end
<<<<<<< HEAD

=======
>>>>>>> 1282ea15881b4a2260f1ab993005874bde3e5c44
    BeforeAfter.__elasticsearch__.refresh_index!
    intercom_event 'created-before-after'
  end

  def edit
    port = ":#{request.try(:port)}" if request.port
    host = website_host @business.website
    post_path = website_before_after_path(@before_after)
    @preview_url = @before_after.published_status != false ? host + port + post_path : [:website, :generic_post, :preview, :type => "before_afters", only_path: false, :host => website_host(@business.website), :id => @before_after.id]
  end


  def update
    @before_after.update(before_after_params)
    if @business.facebook_id? && @business.facebook_token? && params[:facebook_publish] && @before_after.published_on < DateTime.now
      page_graph = Koala::Facebook::API.new(@business.facebook_token)
      if @before_after.facebook_id?
        # Update Post
      else
        result = page_graph.put_connections @business.facebook_id, 'feed', before_after_facebook_params
        @before_after.update_column :facebook_id, result['id']
      end
    end
    if params[:draft]
<<<<<<< HEAD
      @before_after.published_status = false
    else
      @before_after.published_status = true
=======
       @before_after.published_status = false
    else
       @before_after.published_status = true
    end
    respond_to do |format|
      if @before_after.save
        format.html { redirect_to edit_business_content_before_after_path(@business, @before_after), notice: "Draft created successfully" } if params[:draft] 
        format.html { redirect_to business_content_feed_path @business, notice: "Post created successfully" } if !params[:draft]
      else
        format.html { redirect_to new_business_content_before_after_path, :alert => "Title cannot be empty!" }
      end
>>>>>>> 1282ea15881b4a2260f1ab993005874bde3e5c44
    end

    respond_to do |format|
      if @before_after.save
        flash[:notice] = 'Post was successfully created.'
        format.html { redirect_to edit_business_content_before_after_path(@business, @before_after), notice: "Draft created successfully" } if params[:draft] 
        format.html { redirect_to business_content_feed_path @business } if !params[:draft]
      else
        format.html { redirect_to new_business_content_before_after_path, :alert => "Post must have a title" }
      end
    end

    @before_after.__elasticsearch__.index_document
    BeforeAfter.__elasticsearch__.refresh_index!
  end

  def destroy
    destroy_resource @before_after, location: [@business, :content_feed] do |success|
      if success
        begin
          if @business.facebook_id? && @business.facebook_token? && @before_after.facebook_id?
            page_graph = Koala::Facebook::API.new(@business.facebook_token)
            page_graph.delete_object @before_after.facebook_id
          end
        rescue
        end
        BeforeAfter.__elasticsearch__.refresh_index!
      end
    end
  end

  private

  def before_after_params
    params.require(:before_after).permit(
      :description,
      :meta_description,
      :published_on,
      :published_time,
      :title,
      content_category_ids: [],
      content_tag_ids: [],
      after_image_placement_attributes: placement_attributes,
      before_image_placement_attributes: placement_attributes,
      main_image_placement_attributes: placement_attributes,
    ).deep_merge(
      after_image_placement_attributes: {
        image_user: current_user,
        image_business: @business,
      },
      before_image_placement_attributes: {
        image_user: current_user,
        image_business: @business,
      },
      main_image_placement_attributes: {
        image_user: current_user,
        image_business: @business,
      },
    ).tap do |safe_params|
      safe_params[:content_category_ids] = [] unless safe_params[:content_category_ids]
      safe_params[:content_tag_ids] = [] unless safe_params[:content_tag_ids]
    end
  end

  def before_after_facebook_params
    if @before_after.published_on > DateTime.now
      {
        caption: truncate(Sanitize.fragment(@before_after.description, Sanitize::Config::DEFAULT), length: 1000),
        link: url_for([:website, @before_after, only_path: false, host: website_host(@business.website)]),
        name: @before_after.title,
        picture: @before_after.after_image.try(:attachment_url),
        published: true,
        scheduled_published_time: @before_after.published_on,
      }
    else
      {
        backdated_time: @before_after.created_at,
        caption: truncate(Sanitize.fragment(@before_after.description, Sanitize::Config::DEFAULT), length: 1000),
        link: url_for([:website, @before_after, only_path: false, host: website_host(@business.website)]),
        name: @before_after.title,
        picture: @before_after.after_image.try(:attachment_url),
      }
    end
  end
end
