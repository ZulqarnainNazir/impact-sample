class Businesses::Content::EventDefinitionsController < Businesses::Content::BaseController
  include PlacementAttributesConcern

  before_action only: new_actions do
    @event_definition = @business.event_definitions.new
  end

  before_action only: member_actions do
    @event_definition = @business.event_definitions.find(params[:id])
  end

  before_action only: %i[create update] do
    if params[:event_definition]
      if params[:event_definition][:repetition] == 'null'
        params[:event_definition][:repetition] = ''
      end

      if params[:event_definition][:'start_time(4i)'].blank? && params[:event_definition][:'start_time(5i)'].blank?
        params[:event_definition][:'start_time(1i)'] = ''
        params[:event_definition][:'start_time(2i)'] = ''
        params[:event_definition][:'start_time(3i)'] = ''
      end

      if params[:event_definition][:'end_time(4i)'].blank? && params[:event_definition][:'end_time(5i)'].blank?
        params[:event_definition][:'end_time(1i)'] = ''
        params[:event_definition][:'end_time(2i)'] = ''
        params[:event_definition][:'end_time(3i)'] = ''
      end
    end
  end

  def clone
    cloned_event_definition = @business.event_definitions.find(params[:id])
    cloned_attributes = cloned_event_definition.attributes.slice(*cloneable_attributes)
    @event_definition = @business.event_definitions.new(cloned_attributes)
    @event_definition.event_definition_location_attributes = { location_id: cloned_event_definition.location.try(:id) }
    @event_definition.event_image_placement_attributes = { image_id: cloned_event_definition.event_image.try(:id) }
    render :new
  end

 def create
    create_resource @event_definition, event_definition_params, location: [@business, :content_feed] do |success|
      if success
        @event_definition.reschedule_events!
        begin
          if @business.facebook_id? && @business.facebook_token? && params[:facebook_publish]
            page_graph = Koala::Facebook::API.new(@business.facebook_token)
            result = page_graph.put_connections @business.facebook_id, 'feed', event_definition_facebook_params
            @event_definition.update_column :facebook_id, result['id']
          end
        rescue
        end
        EventDefinition.__elasticsearch__.refresh_index!
        intercom_event 'created-event'
      end
    end
  end

  def update
    update_resource @event_definition, event_definition_params, location: [@business, :content_feed] do |success|
      if success
        @event_definition.reschedule_events!
        begin
          if @business.facebook_id? && @business.facebook_token? && params[:facebook_publish]
            page_graph = Koala::Facebook::API.new(@business.facebook_token)
            if @event_definition.facebook_id?
              # Update Post
            else
              result = page_graph.put_connections @business.facebook_id, 'feed', event_definition_facebook_params
              @event_definition.update_column :facebook_id, result['id']
            end
          end
        rescue
        end
        EventDefinition.__elasticsearch__.refresh_index!
      end
    end
  end

  def destroy
    destroy_resource @event_definition, location: [@business, :content_feed] do |success|
      if success
        begin
          if @business.facebook_id? && @business.facebook_token? && @event_definition.facebook_id?
            page_graph = Koala::Facebook::API.new(@business.facebook_token)
            page_graph.delete_object @event_definition.facebook_id
          end
        rescue
        end
        EventDefinition.__elasticsearch__.refresh_index!
      end
    end
  end

  private

  def cloneable_attributes
    %w[title subtitle description price url start_date end_date start_time end_time repeats repetition_days repetition_weeks]
  end

  def event_definition_params
    params.require(:event_definition).permit(
      :description,
      :end_date,
      :end_time,
      :meta_description,
      :price,
      :repetition,
      :start_date,
      :start_time,
      :subtitle,
      :title,
      :url,
      content_category_ids: [],
      content_tag_ids: [],
      event_definition_location_attributes: [:id, :location_id],
      event_image_placement_attributes: placement_attributes,
      main_image_placement_attributes: placement_attributes,
    ).tap do |safe_params|
      merge_placement_image_attributes safe_params, :event_image_placement_attributes
      merge_placement_image_attributes safe_params, :main_image_placement_attributes
      safe_params[:content_category_ids] = [] unless safe_params[:content_category_ids]
      safe_params[:content_tag_ids] = [] unless safe_params[:content_tag_ids]
    end
  end

  def event_definition_facebook_params
    {
      backdated_time: @event_definition.created_at,
      caption: truncate(Sanitize.fragment(@event_definition.description, Sanitize::Config::DEFAULT), length: 1000),
      link: url_for([:website, @event_definition.events.first, only_path: false, host: website_host(@business.website)]),
      name: @event_definition.title,
      picture: @event_definition.event_image.try(:attachment_url),
    }
  end
end
