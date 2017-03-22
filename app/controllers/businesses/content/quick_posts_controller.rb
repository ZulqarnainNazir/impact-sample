class Businesses::Content::QuickPostsController < Businesses::Content::BaseController
  include PlacementAttributesConcern
  include RequiresWebPlanConcern

  before_action only: new_actions do
    @quick_post = @business.quick_posts.new
  end

  before_action only: member_actions do
    @business = Business.find(params[:business_id])
    @quick_post = @business.quick_posts.find(params[:id])
  end

  def clone
    cloned_post = @business.quick_posts.find(params[:id])
    cloned_attributes = cloned_post.attributes.slice(*cloneable_attributes)
    @quick_post = @business.quick_posts.new(cloned_attributes)
    @quick_post.content_category_ids = cloned_post.content_category_ids
    @quick_post.content_tag_ids = cloned_post.content_tag_ids
    @quick_post.quick_post_image_placement_attributes = { image_id: cloned_post.quick_post_image.try(:attachment_url) }
    render :new
  end

  def create
    @quick_post = QuickPost.new(quick_post_params)
    @quick_post.business = @business
    if params[:draft].present?
      @quick_post.published_status = false
    else
      @quick_post.published_status = true
    end
    respond_to do |format|
      if @quick_post.save
        flash[:notice] = 'Post was successfully created.'
        format.html { redirect_to edit_business_content_quick_post_path(@business, @quick_post), notice: "Draft created successfully" } if params[:draft].present?
        format.html { redirect_to new_business_content_quick_post_share_path(@business, @quick_post) } if !params[:draft].present?
      else
        format.html { render :action => "new" }
      end
    end
    QuickPost.__elasticsearch__.refresh_index!
    intercom_event 'created-quick-post'
  end

  def edit
    port = ":#{request.try(:port)}" if request.port
    host = website_host @business.website
    post_path = website_quick_post_path(@quick_post)
    @preview_url = @quick_post.published_status != false ? host + port + post_path : [:website, :generic_post, :preview, :type => "quick_posts", only_path: false, :host => website_host(@business.website), protocol: :http, :id => @quick_post.id]
  end

  def update
    @quick_post.update(quick_post_params)
    if params[:draft]
      @quick_post.published_status = false
    else
      @quick_post.published_status = true
    end
    respond_to do |format|
      if @quick_post.save
        flash[:notice] = 'Post was successfully updated.'
        format.html { redirect_to edit_business_content_quick_post_path(@business, @quick_post), notice: "Draft created successfully" } if params[:draft].present?
        format.html { redirect_to business_content_feed_path @business } if !params[:draft].present?
      else
        format.html { render :action => "edit" }
      end
    end

    @quick_post.__elasticsearch__.index_document
    QuickPost.__elasticsearch__.refresh_index!
  end

  def destroy
    destroy_resource @quick_post, location: [@business, :content_feed] do |success|
      if success
        QuickPost.__elasticsearch__.refresh_index!
      end
    end
  end

  def sharing_insights
    @quick_post = QuickPost.find(params[:quick_post_id])
    @graph = FacebookAnalytics.new(facebook_token: @business.facebook_token)
  end

  private

  def quick_post_params
    params.require(:quick_post).permit(
      :content,
      :meta_description,
      :published_on,
      :published_time,
      :title,
      content_category_ids: [],
      content_tag_ids: [],
      quick_post_image_placement_attributes: placement_attributes,
    ).tap do |safe_params|
      merge_placement_image_attributes safe_params, :quick_post_image_placement_attributes
      safe_params[:content_category_ids] = [] unless safe_params[:content_category_ids]
      safe_params[:content_tag_ids] = [] unless safe_params[:content_tag_ids]
    end
  end

  def cloneable_attributes
    %w[title content]
  end
end
