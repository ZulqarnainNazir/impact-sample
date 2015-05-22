class Website::EventsController < Website::BaseController
  def index
    @events = @business.events.
      where('occurs_on >= ?', Time.zone.now).
      order(occurs_on: :desc).
      page(params[:page]).
      per(20)
  end

  def show
    @event = @business.events.find(params[:id])
  end
end
