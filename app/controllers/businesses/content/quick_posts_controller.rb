class Businesses::Content::QuickPostsController < Businesses::Content::BaseController
  include PlacementAttributesConcern
  include RequiresWebPlanConcern

  before_action only: new_actions do
    @quick_post = @business.quick_posts.new
  end

  before_action only: member_actions do
    @quick_post = @business.quick_posts.find(params[:id])
  end

  def create
    @quick_post = QuickPost.new(quick_post_params)
    @quick_post.business = @business
    @quick_post.save!
    if @business.facebook_id? && @business.facebook_token? && params[:facebook_publish]
      page_graph = Koala::Facebook::API.new(@business.facebook_token)
      result = page_graph.put_connections @business.facebook_id, 'feed', quick_post_facebook_params
      @quick_post.update_column :facebook_id, result['id']
    end
    if params[:draft]
       @quick_post.published_status = false
       if @quick_post.save
         redirect_to edit_business_content_quick_post_path(@business, @quick_post), notice: "Draft created successfully"
         # go straight to post edit page if saved as draft
         return
       end
    else
       @quick_post.published_status = true
       redirect_to business_content_feed_path @business if @quick_post.save
    end
    QuickPost.__elasticsearch__.refresh_index!
    intercom_event 'created-quick-post'
  end

  def edit
    port = ":#{request.try(:port)}" if request.port
    host = website_host @business.website
    post_path = website_quick_post_path(@quick_post)
    @preview_url = @quick_post.published_status != false ? host + port + post_path : [:website, :generic_post, :preview, :type => "quick_posts", only_path: false, :host => website_host(@business.website), :id => @quick_post.id]
  end

  def update
    binding.pry
    @quick_post.update(quick_post_params)
    binding.pry
    binding.pry
    if @business.facebook_id? && @business.facebook_token? && params[:facebook_publish]
      page_graph = Koala::Facebook::API.new(@business.facebook_token)
      if @quick_post.facebook_id?
        # Update Post
      else
        result = page_graph.put_connections @business.facebook_id, 'feed', quick_post_facebook_params
        @quick_post.update_column :facebook_id, result['id']
      end
    end
    if params[:draft]
       @quick_post.published_status = false
       if @quick_post.save
         redirect_to edit_business_content_quick_post_path(@business, @quick_post), notice: "Draft created successfully"
         # go straight to post edit page if saved as draft
         return
       end
    else
       @quick_post.published_status = true
       redirect_to business_content_feed_path @business if @quick_post.save
    end
    @quick_post.__elasticsearch__.index_document
    QuickPost.__elasticsearch__.refresh_index!
  end

  def destroy
    destroy_resource @quick_post, location: [@business, :content_feed] do |success|
      if success
        begin
          if @business.facebook_id? && @business.facebook_token? && @quick_post.facebook_id?
            page_graph = Koala::Facebook::API.new(@business.facebook_token)
            page_graph.delete_object @quick_post.facebook_id
          end
        rescue
        end
        QuickPost.__elasticsearch__.refresh_index!
      end
    end
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

  def quick_post_facebook_params
    if @quick_post.published_at > Time.now
      {
        caption: truncate(Sanitize.fragment(@quick_post.content, Sanitize::Config::DEFAULT), length: 1000),
        link: url_for([:website, @quick_post, only_path: false, host: website_host(@business.website)]),
        name: @quick_post.title,
        picture: @quick_post.quick_post_image.try(:attachment_url),
        published: false,
        scheduled_published_time: @quick_post.published_at.to_i,
      }
    else
      {
        backdated_time: @quick_post.published_at,
        caption: truncate(Sanitize.fragment(@quick_post.content, Sanitize::Config::DEFAULT), length: 1000),
        link: url_for([:website, @quick_post, only_path: false, host: website_host(@business.website)]),
        name: @quick_post.title,
        picture: @quick_post.quick_post_image.try(:attachment_url),
      }
    end
  end
end
