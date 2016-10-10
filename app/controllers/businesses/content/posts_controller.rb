class Businesses::Content::PostsController < Businesses::Content::BaseController
  include PlacementAttributesConcern
  include RequiresWebPlanConcern

  layout 'application'

  before_action only: new_actions do
    @post = @business.posts.new
  end

  before_action only: member_actions do
    @post = @business.posts.find(params[:id])
  end

  def create
    @post = Post.new(post_params)
    @post.business = @business
    @post.save!
    fix_post_section_parent_ids(@post.post_sections)
    if @business.facebook_id? && @business.facebook_token? && params[:facebook_publish]
      page_graph = Koala::Facebook::API.new(@business.facebook_token)
      result = page_graph.put_connections @business.facebook_id, 'feed', post_facebook_params
      @post.update_column :facebook_id, result['id']
    end
    if params[:draft]
       @post.published_status = false
       if @post.save
         redirect_to edit_business_content_post_path(@business, @post), notice: "Draft created successfully"
         # go straight to post edit page if saved as draft
         return
       end
    else
       @post.published_status = true
       redirect_to business_content_feed_path @business if @post.save
    end
    Post.__elasticsearch__.refresh_index!
    intercom_event 'created-custom-post'
  end

  def update
    # binding.pry
    @post.update(post_params)
    @post.save!
    fix_post_section_parent_ids(@post.post_sections)
    if @business.facebook_id? && @business.facebook_token? && params[:facebook_publish]
      page_graph = Koala::Facebook::API.new(@business.facebook_token)
      if @post.facebook_id?
        # Update Post
      else
        result = page_graph.put_connections @business.facebook_id, 'feed', post_facebook_params
        @post.update_column :facebook_id, result['id']
      end
    end
    if params[:draft]
       @post.published_status = false
       if @post.save
         redirect_to edit_business_content_post_path(@business, @post), notice: "Draft created successfully"
         # go straight to post edit page if saved as draft
         return
       end
    else
       @post.published_status = true
       redirect_to business_content_feed_path @business if @post.save
    end
    # binding.pry
    Post.__elasticsearch__.index_name
    # binding.pry
    Post.__elasticsearch__.refresh_index!
  end

  def edit
    port = ":#{request.try(:port)}" if request.port
    host = website_host @business.website
    post_path = website_post_path(@post)
    @preview_url = @post.published_status != false ? host + port + post_path : [:website, :generic_post, :preview, :type => "posts", only_path: false, :host => website_host(@business.website), :id => @post.id]
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
          section.update! parent_id: parent.id
        end
      else
        section.update! parent_id: nil
      end
    end
  end

  def post_facebook_params
    if @post.published_at > Time.now
      {
        caption: truncate(Sanitize.fragment(@post.sections_content, Sanitize::Config::DEFAULT), length: 1000),
        link: url_for([:website, @post, only_path: false, host: website_host(@business.website)]),
        name: @post.title,
        picture: @post.post_sections.first.try(:post_section_image).try(:attachment_url),
        published: false,
        scheduled_publish_time: @post.published_at.to_i,
      }
    else
      {
        backdated_time: @post.published_at,
        caption: truncate(Sanitize.fragment(@post.sections_content, Sanitize::Config::DEFAULT), length: 1000),
        link: url_for([:website, @post, only_path: false, host: website_host(@business.website)]),
        name: @post.title,
        picture: @post.post_sections.first.try(:post_section_image).try(:attachment_url),
      }
    end
  end
end
