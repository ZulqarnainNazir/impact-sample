class Website::EventsController < Website::BaseController
  def index
    @events = @business.events.
      where('occurs_on >= ?', Time.zone.now).
      order(occurs_on: :asc).
      page(params[:page]).
      per(20)
  end

  def show
    @event = @business.events.find(params[:id])
    @upcoming_events = @event.event_definition.events.
      where.not(id: @event.id).
      where('occurs_on >= ?', Time.zone.now).
      order(occurs_on: :asc).
      page(1).
      per(4)
  end
end
