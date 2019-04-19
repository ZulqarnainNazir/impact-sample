class Async::WidgetsController < ApplicationController
  include EventSearchConcern
  include ContentSearchConcern

  def calendar
    @event = Event.find(params.dig(:event))
    @business = @event.business
    @website = @business.website

    # TODO - Add option to search to exlude current event
    # @upcoming_events = get_events(business: @event.business, per_page: 4)
    @upcoming_events = @event.event_definition.events.where.not(id: @event.id).where('occurs_on >= ?', Time.zone.now).order(occurs_on: :asc).page(1).per(4)
    render layout: false
  end

  def quick_post
    @quick_post = QuickPost.find(params.dig(:quick_post))
    render layout: false
  end
end
