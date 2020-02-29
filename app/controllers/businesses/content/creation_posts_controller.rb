class Businesses::Content::CreationPostsController < Businesses::Content::BaseController
  include PlacementAttributesConcern

  before_action only: new_actions do
    @creation_post = @business.creation_posts.new
    @prompts = YAML.load_file('config/content_type_prompts/creation_post_prompts.yml')

  end

  before_action only: member_actions do
    @business = Business.find(params[:business_id])
    @creation_post = @business.creation_posts.find(params[:id])
  end

  def clone
    cloned_post = @business.creation_posts.find(params[:id])
    cloned_attributes = cloned_post.attributes.slice(*cloneable_attributes)
    @creation_post = @business.creation_posts.new(cloned_attributes)
    @creation_post.content_category_ids = cloned_post.content_category_ids
    @creation_post.content_tag_ids = cloned_post.content_tag_ids
    @creation_post.creation_post_image_placement_attributes = { image_id: cloned_post.creation_post_image.try(:attachment_url) }
    render :new
  end

  def create
    modified_creation_post_params = creation_post_params
    time_published_on = Time.parse(creation_post_params["published_on"])
    modified_creation_post_params["published_on"] = DateTime.parse(time_published_on.utc.to_s).strftime("%b %d %Y %I:%M %p %z")

    @creation_post = CreationPost.new(modified_creation_post_params)
    @creation_post.business = @business

    if params[:draft].present?
      @creation_post.published_status = false
    else
      @creation_post.published_status = true
    end
    respond_to do |format|
      if @creation_post.save
        # flash[:appcues_event] = "Appcues.track('created quick post')"
        @creation_post.__elasticsearch__.index_document
        flash[:notice] = 'Post was successfully created.'
        format.html { redirect_to edit_business_content_creation_post_path(@business, @creation_post), notice: "Draft created successfully" } if params[:draft].present?
        format.html { redirect_to edit_business_content_creation_post_path(@business, @creation_post) } if !params[:draft].present?
      else
        flash[:notice] = 'Something went wrong - please try again.'
        format.html { render :action => "new" }
      end
    end
    CreationPost.__elasticsearch__.refresh_index!
    intercom_event 'created-highlight-creation'
  end

  def edit
    port = ":#{request.try(:port)}" if request.port
    post_path = website_creation_post_path(@creation_post)
    @preview_url = @creation_post.published_status != false ? @business.website.host + port + post_path : [:website, :generic_post, :preview, :type => "creation_posts", only_path: false, :host => @business.website.host, protocol: :http, :id => @creation_post.id]

    @prompts = YAML.load_file('config/content_type_prompts/creation_post_prompts.yml')

  end

  def update
    if params[:draft].present?
      @creation_post.published_status = false
    else
      @creation_post.published_status = true
    end
    respond_to do |format|
      if @creation_post.update(creation_post_params)
        @creation_post.__elasticsearch__.index_document
        flash[:notice] = 'Post was successfully updated.'

        format.html { redirect_to edit_business_content_creation_post_path(@business, @creation_post), notice: "Draft updated." } if params[:draft].present?
        format.html { redirect_to edit_business_content_creation_post_path(@business, @creation_post) } if !params[:draft].present?

      else
        flash[:notice] = 'Something went wrong - please try again.'
        format.html { render :action => "edit" }
      end
    end
    #@quick_post.__elasticsearch__.index_document
    #QuickPost.__elasticsearch__.refresh_index!
  end

  def destroy
    destroy_resource @creation_post, location: [@business, :content_root] do |success|
      if success
        CreationPost.__elasticsearch__.refresh_index!
      end
    end
  end

  def sharing_insights
    @creation_post = CreationPost.find(params[:creation_post_id])
    @graph = FacebookAnalytics.new(facebook_token: @business.facebook_token)
  end

  private

  def creation_post_params
    params.require(:creation_post).permit(
      :content,
      :meta_description,
      :published_on,
      :published_time,
      :title,
      content_category_ids: [],
      content_tag_ids: [],
      creation_post_image_placement_attributes: placement_attributes,
      main_image_placement_attributes: placement_attributes,
    ).tap do |safe_params|
      merge_placement_image_attributes safe_params, :creation_post_image_placement_attributes
      merge_placement_image_attributes safe_params, :main_image_placement_attributes
      safe_params[:content_category_ids] = [] unless safe_params[:content_category_ids]
      safe_params[:content_tag_ids] = [] unless safe_params[:content_tag_ids]
    end
  end

  def cloneable_attributes
    %w[title content]
  end
end
