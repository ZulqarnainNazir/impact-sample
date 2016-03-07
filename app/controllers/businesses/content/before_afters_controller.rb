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
    create_resource @before_after, before_after_params, location: [@business, :content_feed] do |success|
      if success
        begin
          if @business.facebook_id? && @business.facebook_token? && params[:facebook_publish]
            page_graph = Koala::Facebook::API.new(@business.facebook_token)
            result = page_graph.put_connections @business.facebook_id, 'feed', before_after_facebook_params
            @before_after.update_column :facebook_id, result['id']
          end
        rescue
        end
        BeforeAfter.__elasticsearch__.refresh_index!
        intercom_event 'created-before-after'
      end
    end
  end

  def update
    update_resource @before_after, before_after_params, location: [@business, :content_feed] do |success|
      if success
        begin
          if @business.facebook_id? && @business.facebook_token? && params[:facebook_publish]
            page_graph = Koala::Facebook::API.new(@business.facebook_token)
            if @before_after.facebook_id?
              page_graph.put_connections @before_after.facebook_id, before_after_facebook_params
            else
              result = page_graph.put_connections @business.facebook_id, 'feed', before_after_facebook_params
              @before_after.update_column :facebook_id, result['id']
            end
          end
        rescue
        end
        BeforeAfter.__elasticsearch__.refresh_index!
      end
    end
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
    if @before_after.published_at > Time.now
      {
        caption: truncate(Sanitize.fragment(@before_after.description, Sanitize::Config::DEFAULT), length: 1000),
        link: url_for([:website, @before_after, only_path: false, host: website_host(@business.website)]),
        name: @before_after.title,
        picture: @before_after.after_image.try(:attachment_url),
        published: false,
        scheduled_published_time: @before_after.published_at.to_i,
      }
    else
      {
        backdated_time: @before_after.published_at,
        caption: truncate(Sanitize.fragment(@before_after.description, Sanitize::Config::DEFAULT), length: 1000),
        link: url_for([:website, @before_after, only_path: false, host: website_host(@business.website)]),
        name: @before_after.title,
        picture: @before_after.after_image.try(:attachment_url),
      }
    end
  end
end
