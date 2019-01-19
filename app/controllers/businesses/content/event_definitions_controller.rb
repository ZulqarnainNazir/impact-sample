class Businesses::Content::EventDefinitionsController < Businesses::Content::BaseController
  include PlacementAttributesConcern
  include EventDefinitionsConcern

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
        flash[:appcues_event] = "Appcues.track('created event')"
        @event_definition.reschedule_events!
        @event_definition.__elasticsearch__.index_document
        flash[:notice] = 'Event successfully created.'
        format.html { redirect_to edit_business_content_event_definition_path(@business, @event_definition), notice: "Draft event saved" } if params[:draft].present?
        format.html { redirect_to edit_business_content_event_definition_path(@business, @event_definition), notice: "Event created successfully" } if !params[:draft].present?
      else
        flash[:notice] = 'Something went wrong - please try again.'
        format.html { render :action => "new" }
      end
    end
    #@event_definition.__elasticsearch__.index_document
    #EventDefinition.__elasticsearch__.refresh_index!
    intercom_event 'created-event'
  end

  def update
    prepare_for_event_update
    respond_to do |format|
      if @event_definition.update(event_definition_params)
        @event_definition.reschedule_events!
        @event_definition.__elasticsearch__.index_document
        flash[:notice] = 'Event was successfully updated.'

        format.html { redirect_to edit_business_content_event_definition_path(@business, @event_definition), notice: "Draft updated." } if params[:draft].present?
        format.html { redirect_to edit_business_content_event_definition_path(@business, @event_definition) } if !params[:draft].present?

      else
        flash[:notice] = 'Something went wrong - please try again.'
        format.html { render :action => "edit" }
      end
    end
    #EventDefinition.__elasticsearch__.refresh_index!
  end


  def edit
    port = ":#{request.try(:port)}" if request.port
    post_path = website_event_path
    @preview_url = @event_definition.published_status != false ? @business.website.host + port + post_path : [:website, :generic_post, :preview, :type => "events", only_path: false, :host => @business.website.host, protocol: :http, :id => @event_definition.id]
  end

  def destroy
    destroy_resource @event_definition, location: [@business, :content_root] do |success|
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
end
