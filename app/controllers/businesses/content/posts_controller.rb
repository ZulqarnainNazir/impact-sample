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
    create_resource @post, post_params, location: [@business, :content_feed] do |success|
      if success
        fix_post_section_parent_ids(@post.post_sections)
        begin
          if @business.facebook_id? && @business.facebook_token? && params[:facebook_publish]
            page_graph = Koala::Facebook::API.new(@business.facebook_token)
            result = page_graph.put_connections @business.facebook_id, 'feed', post_facebook_params
            @post.update_column :facebook_id, result['id']
          end
        rescue
        end
        Post.__elasticsearch__.refresh_index!
        intercom_event 'created-custom-post'
      end
    end
  end

  def update
    update_resource @post, post_params, location: [@business, :content_feed] do |success|
      if success
        fix_post_section_parent_ids(@post.post_sections)
        begin
          if @business.facebook_id? && @business.facebook_token? && params[:facebook_publish]
            page_graph = Koala::Facebook::API.new(@business.facebook_token)
            if @post.facebook_id?
              # Update Post
            else
              result = page_graph.put_connections @business.facebook_id, 'feed', post_facebook_params
              @post.update_column :facebook_id, result['id']
            end
          end
        rescue
        end
        @post.__elasticsearch__.index_document
        Post.__elasticsearch__.refresh_index!
      end
    end
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
    if @post.published_on > Time.now
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
