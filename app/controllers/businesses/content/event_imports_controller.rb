class Businesses::Content::EventImportsController < Businesses::Content::BaseController
  before_action only: :index do
    @event_feeds = EventFeed.for_business(@business)
  end

  before_action do
    @locable_business = LocableBusiness.find_by_id(@business.cce_id) if @business.cce_id?
  end

  def import_all
    @locable_business.events.where('external_type IS NULL OR external_type != ?', 'impact').each do |locable_event|
      locable_event.import(@business).reschedule_events!
    end
    EventDefinition.__elasticsearch__.refresh_index!
    redirect_to [@business, :content_event_imports], notice: 'The events wwasere successfully imported into your content library'
  end

  def import
    locable_event = @locable_business.events.where('external_type IS NULL OR external_type != ?', 'impact').find(params[:id])
    locable_event.import(@business).reschedule_events!
    EventDefinition.__elasticsearch__.refresh_index!
    redirect_to [@business, :content_event_imports], notice: 'The event was successfully imported into your content library'
  end
end
