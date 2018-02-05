class Website::EventsController < Website::BaseController
  def index
    @events = @business.events.
      where('occurs_on >= ?', Time.zone.now).joins(:event_definition).where(:event_definitions => {published_status: true}).
      order(occurs_on: :asc).
      page(params[:page]).
      per(20)
  end

  def show
    @event = @business.events.find(params[:id])
    generic_params = @event.to_generic_param
    if params[:uuid] =~ /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/
      generic_params[:uuid] = params[:uuid]
    end
    redirect_to website_generic_post_path(generic_params), status: 301
  end
end
