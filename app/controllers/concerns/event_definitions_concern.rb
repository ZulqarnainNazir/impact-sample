module EventDefinitionsConcern
  extend ActiveSupport::Concern

  def prepare_for_event_update
    if params[:imported_event_definition].present?
      params[:event_definition].merge! params[:imported_event_definition]
    end

    if !params[:event_definition][:virtual_event].present?
      @event_definition.virtual_event = false
    end

    if params[:event_definition][:event_definition_location_attributes][:location_id].empty? && @event_definition.event_definition_location.present?
      params[:event_definition][:event_definition_location_attributes][:location_id] = @event_definition.event_definition_location.location_id
    end

    if params[:draft].present?
      @event_definition.published_status = false
    else
      @event_definition.published_status = true
    end
  end

  def event_definition_params
    permitted_params params.require(:event_definition)
  end

  def imported_event_definition_params
    permitted_params params.require(:imported_event_definition)
  end

  def permitted_params(required_params)
    required_params.permit(
      :description,
      :end_date,
      :end_time,
      :meta_description,
      :embed,
      :price,
      :repetition,
      :start_date,
      :start_time,
      :subtitle,
      :title,
      :url,
      :kind,
      :hide_full_address,
      :show_city_only,
      :private,
      :virtual_event,
      :rsvp_required,
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
end
