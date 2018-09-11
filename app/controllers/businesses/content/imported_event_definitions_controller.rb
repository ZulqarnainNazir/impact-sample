class Businesses::Content::ImportedEventDefinitionsController < Businesses::Content::BaseController
  include EventDefinitionsConcern
  include PlacementAttributesConcern

  before_action :set_event_feed
  before_action :set_event_definition

  before_action only: %i[create update] do
    if params[:imported_event_definition]
      if params[:imported_event_definition][:repetition] == 'null'
        params[:imported_event_definition][:repetition] = ''
      end
    end
  end

  def edit
    @event_feed = EventFeed.find(params[:event_feed_id])
    @event_definition = ImportedEventDefinition.find(params[:id])
    @event_definition.published_status = true
    @event_definition.valid? && @event_definition.location.valid?
  end

  def update
    prepare_for_event_update

    if params[:draft].present?
      @event_definition.import_pending = true
      @event_definition.published_status = false
    else
       @event_definition.published_status = true
       @event_definition.import_pending = false
    end

    if @event_definition.update(event_definition_params.merge(imported_event_definition_params))
      @event_definition.reschedule_events!
      @event_definition.__elasticsearch__.index_document
      flash[:notice] = 'Event was successfully updated.'

      if params[:draft].present?
        redirect_to edit_business_content_event_feed_imported_event_definition_path(@business, @event_feed, @event_definition), notice: "Draft updated."
      end
      if !params[:draft].present?
        redirect_to edit_business_content_event_feed_imported_event_definition_path(@business, @event_feed, @event_definition)
      end
    else
      flash[:alert] = 'Unable to save event, please correct the issues highlighted below'
      render action: :edit
    end
  end

  def destroy
    @event_definition.archive!

    redirect_to business_content_event_feed_path(@business, @event_feed), notice: 'Imported item removed'
  end

  private

  def set_event_feed
    @event_feed = EventFeed.find(params[:event_feed_id])
  end

  def set_event_definition
    @event_definition = EventDefinition.find(params[:id])
  end
end
