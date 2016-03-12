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
    redirect_to website_generic_post_path(@event.to_generic_param), status: 301
  end
end
