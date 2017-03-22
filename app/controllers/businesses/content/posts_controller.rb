class Businesses::Content::PostsController < Businesses::Content::BaseController
  include PlacementAttributesConcern
  include RequiresWebPlanConcern

  layout 'business_reduced'

  before_action only: new_actions do
    @post = @business.posts.new
  end

  before_action only: member_actions do
    @post = @business.posts.find(params[:id])
  end

  def clone
    post = @business.posts.find(params[:id])
    ps_array = []
    @post = post.dup
    post.post_sections.each do |ps|
      cloned_ps = ps.dup
      cloned_ps.post_section_image_placement_attributes = { image_id: ps.post_section_image.try(:id) }
      ps_array.push(cloned_ps)
    end
    @post.post_sections = ps_array
    @post.content_category_ids = post.content_category_ids
    @post.content_tag_ids = post.content_tag_ids
    @post.main_image_placement_attributes = { image_id: post.main_image.try(:id) }
    @post.published_on = nil
    render :new
  end

  def create
    @post = Post.new(post_params)
    @post.post_sections.each do |ps|
      ps.post = @post
    end
    @post.business = @business
    fix_post_section_parent_ids(@post.post_sections)
    if @business.facebook_id? && @business.facebook_token? && params[:facebook_publish] && @post.published_on < DateTime.now
      page_graph = Koala::Facebook::API.new(@business.facebook_token)
      result = page_graph.put_connections @business.facebook_id, 'feed', post_facebook_params
      @post.update_column :facebook_id, result['id']
    end
    if params[:draft].present?
      @post.published_status = false
    else
      @post.published_status = true
    end
    respond_to do |format|
      if @post.save
        flash[:notice] = 'Post was successfully created.'
        format.html { redirect_to edit_business_content_post_path(@business, @post), notice: "Post created successfully" } if params[:draft].present?
        format.html { redirect_to business_content_feed_path @business } if !params[:draft].present?
      else
        format.html { render :action => "new" }
      end
    end
    Post.__elasticsearch__.refresh_index!
    intercom_event 'created-custom-post'
  end

  def update
    @post.update(post_params)
    fix_post_section_parent_ids(@post.post_sections)
    if @business.facebook_id? && @business.facebook_token? && params[:facebook_publish] && @post.published_on < DateTime.now
      page_graph = Koala::Facebook::API.new(@business.facebook_token)
      if @post.facebook_id?
        # Update Post
      else
        result = page_graph.put_connections @business.facebook_id, 'feed', post_facebook_params
        @post.update_column :facebook_id, result['id']
      end
    end
    if params[:draft].present?
      @post.published_status = false
    else
      @post.published_status = true
    end


    respond_to do |format|
      if @post.save
        flash[:notice] = 'Post was successfully updated.'
        format.html { redirect_to edit_business_content_post_path(@business, @post), notice: "Draft created successfully" } if params[:draft].present?
        format.html { redirect_to business_content_feed_path @business } if !params[:draft].present?
      else
        format.html { render :action => "edit" }
      end
    end
    @post.__elasticsearch__.index_document
    Post.__elasticsearch__.refresh_index!
  end

  def edit
    port = ":#{request.try(:port)}" if request.port
    host = website_host @business.website
    post_path = website_post_path(@post)
    @preview_url = @post.published_status != false ? host + port + post_path : [:website, :generic_post, :preview, :type => "posts", only_path: false, :host => website_host(@business.website), protocol: :http, :id => @post.id]
  end

  def destroy
    destroy_resource @post, location: [@business, :content_feed] do |success|
      if success
        begin
          if @business.facebook_id? && @business.facebook_token? && @post.facebook_id?
            page_graph = Koala::Facebook::API.new(@business.facebook_token)
            page_graph.delete_object @post.facebook_id
          end
        rescue
        end
        Post.__elasticsearch__.refresh_index!
      end
    end
  end

  def sharing_insights
    @post = Post.find(params[:post_id])
    @graph = FacebookAnalytics.new(facebook_token: @business.facebook_token)
  end

  private

  def post_params
    params.require(:post).permit(
      :meta_description,
      :published_on,
      :published_time,
      :title,
      content_category_ids: [],
      content_tag_ids: [],
      main_image_placement_attributes: placement_attributes,
      post_sections_attributes: [
        :id,
        :key,
        :parent_key,
        :kind,
        :position,
        :heading,
        :content,
        :_destroy,
        post_section_image_placement_attributes: placement_attributes,
      ],
    ).tap do |safe_params|
      merge_placement_image_attributes safe_params, :main_image_placement_attributes
      merge_placement_image_attributes_array safe_params[:post_sections_attributes], :post_section_image_placement_attributes
      if safe_params[:post_sections_attributes]
        safe_params[:post_sections_attributes].each do |_, attr|
          attr.merge! post: @post
        end
      end
      safe_params[:content_category_ids] = [] unless safe_params[:content_category_ids]
      safe_params[:content_tag_ids] = [] unless safe_params[:content_tag_ids]
    end
  end

  def fix_post_section_parent_ids(sections)
    sections.each do |section|
      if section.parent_key.present?
        parent = sections.find { |s| s.key == section.parent_key }
        if parent
          section.update parent_id: parent.id
        end
      else
        section.update parent_id: nil
      end
    end
  end

  def cloneable_attributes
    %w[title description meta_description post_sections_attributes content_category_ids content_tag_ids main_image_placement_attributes]
  end

  def post_facebook_params
    if @post.published_on > DateTime.now
      {
        caption: truncate(Sanitize.fragment(@post.sections_content, Sanitize::Config::DEFAULT), length: 1000),
        link: url_for([:website, @post, only_path: false, host: website_host(@business.website), protocol: :http]),
        name: @post.title,
        picture: @post.post_sections.first.try(:post_section_image).try(:attachment_url),
        published: true,
        scheduled_published_time: @post.published_on,
      }
    else
      {
        backdated_time: @post.created_at,
        caption: truncate(Sanitize.fragment(@post.sections_content, Sanitize::Config::DEFAULT), length: 1000),
        link: url_for([:website, @post, only_path: false, host: website_host(@business.website), protocol: :http]),
        name: @post.title,
        picture: @post.post_sections.first.try(:post_section_image).try(:attachment_url),
      }
    end
  end
end
