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
    create_resource @quick_post, quick_post_params, location: [@business, :content_feed] do |success|
      if success
        begin
          if @business.facebook_id? && @business.facebook_token? && params[:facebook_publish]
            page_graph = Koala::Facebook::API.new(@business.facebook_token)
            result = page_graph.put_connections @business.facebook_id, 'feed', quick_post_facebook_params
            @quick_post.update_column :facebook_id, result['id']
          end
        rescue
        end
        QuickPost.__elasticsearch__.refresh_index!
        intercom_event 'created-quick-post'
      end
    end
  end

  def update
    update_resource @quick_post, quick_post_params, location: [@business, :content_feed] do |success|
      if success
        begin
          if @business.facebook_id? && @business.facebook_token? && params[:facebook_publish]
            page_graph = Koala::Facebook::API.new(@business.facebook_token)
            if @quick_post.facebook_id?
              # Update Post
            else
              result = page_graph.put_connections @business.facebook_id, 'feed', quick_post_facebook_params
              @quick_post.update_column :facebook_id, result['id']
            end
          end
        rescue
        end
        @quick_post.__elasticsearch__.index_document
        QuickPost.__elasticsearch__.refresh_index!
      end
    end
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
