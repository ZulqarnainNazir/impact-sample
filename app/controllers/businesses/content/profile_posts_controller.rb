class Businesses::Content::ProfilePostsController < Businesses::Content::BaseController
  include PlacementAttributesConcern

  before_action only: new_actions do
    @profile_post = @business.profile_posts.new
    @prompts = GuidedPostPrompt.where(post_type: 1, industry: 'general').order('section_type asc')
  end

  before_action only: member_actions do
    @business = Business.find(params[:business_id])
    @profile_post = @business.profile_posts.find(params[:id])
  end

  # def clone
  #   cloned_post = @business.profile_posts.find(params[:id])
  #   cloned_attributes = cloned_post.attributes.slice(*cloneable_attributes)
  #   @profile_post = @business.profile_posts.new(cloned_attributes)
  #   @profile_post.content_category_ids = cloned_post.content_category_ids
  #   @profile_post.content_tag_ids = cloned_post.content_tag_ids
  #   @profile_post.profile_post_image_placement_attributes = { image_id: cloned_post.profile_post_image.try(:attachment_url) }
  #   render :new
  # end

  def create
    modified_profile_post_params = profile_post_params
    time_published_on = Time.parse(profile_post_params["published_on"])
    modified_profile_post_params["published_on"] = DateTime.parse(time_published_on.utc.to_s).strftime("%b %d %Y %I:%M %p %z")

    @profile_post = ProfilePost.new(modified_profile_post_params)
    @profile_post.business = @business

    if params[:draft].present?
      @profile_post.published_status = false
    else
      @profile_post.published_status = true
    end

    respond_to do |format|
      if @profile_post.save
        # flash[:appcues_event] = "Appcues.track('created quick post')"
        # @profile_post.__elasticsearch__.index_document
        flash[:notice] = 'Post was successfully created.'
        format.html { redirect_to edit_business_content_profile_post_path(@business, @profile_post), notice: "Draft created successfully" } if params[:draft].present?
        format.html { redirect_to edit_business_content_profile_post_path(@business, @profile_post) } if !params[:draft].present?
      else
        flash[:notice] = 'Something went wrong - please try again.'
        format.html { render :action => "new" }
      end
    end
    # CreationPost.__elasticsearch__.refresh_index!
    intercom_event 'created-profile-post'
  end

  def edit
    port = ":#{request.try(:port)}" if request.port
    post_path = website_profile_post_path(@profile_post)
    @preview_url = @profile_post.published_status != false ? @business.website.host + port + post_path : [:website, :generic_post, :preview, :type => "profile_posts", only_path: false, :host => @business.website.host, protocol: :http, :id => @profile_post.id]

    @prompts = GuidedPostPrompt.where(post_type: 1, industry: 'general').order('section_type asc')

  end

  def update
    if params[:draft].present?
      @profile_post.published_status = false
    else
      @profile_post.published_status = true
    end
    respond_to do |format|
      if @profile_post.update(profile_post_params)
        # @profile_post.__elasticsearch__.index_document
        flash[:notice] = 'Post was successfully updated.'

        format.html { redirect_to edit_business_content_profile_post_path(@business, @profile_post), notice: "Draft updated." } if params[:draft].present?
        format.html { redirect_to edit_business_content_profile_post_path(@business, @profile_post) } if !params[:draft].present?

      else
        flash[:notice] = 'Something went wrong - please try again.'
        format.html { render :action => "edit" }
      end
    end
    #@quick_post.__elasticsearch__.index_document
    #QuickPost.__elasticsearch__.refresh_index!
  end

  def destroy
    destroy_resource @profile_post, location: [@business, :content_root] do |success|
      # if success
      #   begin
      #     if @business.facebook_id? && @business.facebook_token? && @post.facebook_id?
      #       page_graph = Koala::Facebook::API.new(@business.facebook_token)
      #       page_graph.delete_object @post.facebook_id
      #     end
      #   rescue
      #   end
      #   Post.__elasticsearch__.refresh_index!
      # end
    end
  end

  # def sharing_insights
  #   @profile_post = CreationPost.find(params[:profile_post_id])
  #   @graph = FacebookAnalytics.new(facebook_token: @business.facebook_token)
  # end

  private

  def profile_post_params
    params.require(:profile_post).permit(
      :meta_description,
      :published_on,
      :published_time,
      :title,
      content_category_ids: [],
      content_tag_ids: [],
      main_image_placement_attributes: placement_attributes,
      guided_post_sections_attributes: [
        :id,
        :kind,
        :heading,
        :content,
        :position,
        :_destroy,
        guided_post_section_image_placement_attributes: placement_attributes,
      ],
    ).tap do |safe_params|
      merge_placement_image_attributes safe_params, :main_image_placement_attributes
      merge_placement_image_attributes_array safe_params[:guided_post_sections_attributes], :guided_post_section_image_placement_attributes
      if safe_params[:guided_post_sections_attributes]
        safe_params[:guided_post_sections_attributes].each do |_, attr|
          attr.merge! sectionable_id: @profile_post.id
        end
      end
      safe_params[:content_category_ids] = [] unless safe_params[:content_category_ids]
      safe_params[:content_tag_ids] = [] unless safe_params[:content_tag_ids]
    end
  end

  # def cloneable_attributes
  #   %w[title description meta_description guided_post_sections_attributes content_category_ids content_tag_ids main_image_placement_attributes]
  # end
end
