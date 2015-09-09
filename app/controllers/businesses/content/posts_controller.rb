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
        Post.__elasticsearch__.refresh_index!
        intercom_event 'created-custom-post'
      end
    end
  end

  def update
    update_resource @post, post_params, location: [@business, :content_feed] do |success|
      if success
        fix_post_section_parent_ids(@post.post_sections)
        Post.__elasticsearch__.refresh_index!
      end
    end
  end

  def destroy
    destroy_resource @post, location: [@business, :content_feed] do |success|
      Post.__elasticsearch__.refresh_index! if success
    end
  end

  private

  def post_params
    params.require(:post).permit(
      :meta_description,
      :published_on,
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
end
