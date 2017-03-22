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
    end
  end

  def clone
    cloned_event_definition = @business.event_definitions.find(params[:id])
    cloned_attributes = cloned_event_definition.attributes.slice(*cloneable_attributes)
    @event_definition = @business.event_definitions.new(cloned_attributes)
    @event_definition.content_category_ids = cloned_event_definition.content_category_ids
    @event_definition.content_tag_ids = cloned_event_definition.content_tag_ids
    @event_definition.event_definition_location_attributes = { location_id: cloned_event_definition.location.try(:id) }
    @event_definition.event_image_placement_attributes = { image_id: cloned_event_definition.event_image.try(:id) }
    render :new
  end

  def create
    @event_definition = EventDefinition.new(event_definition_params)
    @event_definition.business = @business
    if @business.facebook_id? && @business.facebook_token? && params[:facebook_publish]
      page_graph = Koala::Facebook::API.new(@business.facebook_token)
      result = page_graph.put_connections @business.facebook_id, 'feed', event_definition_facebook_params
      @event_definition.update_column :facebook_id, result['id']
    end
    if params[:draft].present?
      @event_definition.published_status = false
    else
      @event_definition.published_status = true
    end
    respond_to do |format|
      if @event_definition.save
        @event_definition.reschedule_events!
        flash[:notice] = 'Event was successfully created.'
        format.html { redirect_to edit_business_content_event_definition_path(@business, @event_definition), notice: "Draft created successfully" } if params[:draft].present?
        format.html { redirect_to new_business_content_event_definition_share_path(@business, @event_definition), notice: "Post created successfully" } if !params[:draft].present?
      else
        format.html { render :action => "new" }
      end
    end
    @event_definition.__elasticsearch__.index_document
    EventDefinition.__elasticsearch__.refresh_index!
    intercom_event 'created-event'
  end

  def update
    if !params[:event_definition][:virtual_event].present?
      @event_definition.virtual_event = false
    end
    if params[:event_definition][:event_definition_location_attributes][:location_id].empty? && @event_definition.event_definition_location.present?
      params[:event_definition][:event_definition_location_attributes][:location_id] = @event_definition.event_definition_location.location_id
    end
    @event_definition.update(event_definition_params)
    @event_definition.reschedule_events!
    if params[:draft].present?
      @event_definition.published_status = false
    else
      @event_definition.published_status = true
    end
    respond_to do |format|
      if @event_definition.save
        flash[:notice] = 'Event was successfully updated.'
        format.html { redirect_to edit_business_content_event_definition_path(@business, @event_definition), notice: "Draft created successfully" } if params[:draft].present?
        format.html { redirect_to business_content_feed_path @business } if !params[:draft].present?
      else
        format.html { render :action => "edit" }
      end
    end
    EventDefinition.__elasticsearch__.refresh_index!
  end


  def edit
    port = ":#{request.try(:port)}" if request.port
    host = website_host @business.website
    post_path = website_event_path
    @preview_url = @event_definition.published_status != false ? host + port + post_path : [:website, :generic_post, :preview, :type => "events", only_path: false, :host => website_host(@business.website), protocol: :http, :id => @event_definition.id]
  end

  def destroy
    destroy_resource @event_definition, location: [@business, :content_feed] do |success|
      if success
        EventDefinition.__elasticsearch__.refresh_index!
      end
    end
  end

  def sharing_insights
    @event_definition = EventDefinition.find(params[:event_definition_id])
    @graph = FacebookAnalytics.new(facebook_token: @business.facebook_token)
  end

  private

  def cloneable_attributes
    %w[title subtitle description price url start_date end_date start_time end_time repeats repetition_days repetition_weeks hide_full_address show_city_only private virtual_event rsvp_required kind]
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
