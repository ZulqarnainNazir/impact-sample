class Super::EventFeedsController < SuperController
  def index
    @event_feeds = EventFeed.includes(:business)
  end

  def new
    @event_feed = EventFeed.new
  end

  def edit
    @event_feed = EventFeed.find(params[:id])
  end

  def create
    @event_feed = EventFeed.new(event_feed_params)

    if @event_feed.save
      redirect_to super_event_feeds_path, notice: 'Event Feed Added'
    else
      render :new
    end
  end

  def update
    @event_feed = EventFeed.find(params[:id])

    if @event_feed.update(event_feed_params)
      redirect_to super_event_feeds_path, notice: 'Event Feed Updated'
    else
      render :edit
    end
  end

  def destroy
    @event_feed = EventFeed.find(params[:id])
    @event_feed.destroy
    redirect_to super_event_feeds_path, notice: 'Event Feed Destroyed'
  end

  def event_feed_params
    params.require(:event_feed).permit(:name, :url, :business_id)
  end
end
