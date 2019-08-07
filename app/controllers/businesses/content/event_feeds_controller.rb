class Businesses::Content::EventFeedsController < Businesses::Content::BaseController
  before_action except: [:new, :create] do
    @event_feed = EventFeed.find(params[:id])
  end

  def show
    if !authorized_for_event_feed?
      redirect_to business_content_event_imports_path, alert: "Unauthorized to view this event feed."
      return
    end
    if params[:published]
      @imported_event_definitions = ImportedEventDefinition.published_events_for_feed(@event_feed)
    else
      @imported_event_definitions = ImportedEventDefinition.unpublished_events_for_feed(@event_feed)
    end
  end

  def reprocess
    @event_feed.import

    redirect_to [@business, :content, @event_feed], notice: "This feed has been queued for processing. Please refresh the page to see updates as the feed is imported. Once the import is finished, we'll send an email notification."
  end

  def new
    @event_feed = EventFeed.new
    @event_feed.build_location
    @unclaimed_business = @business.owned_businesses.find { |b| b.id.to_s == params[:unclaimed_id] }
  end

  def edit
    if !authorized_for_event_feed?
      redirect_to business_content_event_imports_path, alert: "Unauthorized to edit this event feed."
      return
    end

    @event_feed.location || @event_feed.build_location
  end

  def create
    @event_feed = EventFeed.new(event_feed_params)
    @event_feed.creator = current_user

    upload_file

    if @event_feed.save
      redirect_to business_content_event_imports_path, notice: "This feed has been created and queued for processing. Once the import is finished, we'll send an email notification."
    elsif @event_feed.errors.full_messages.join.match(/unable to parse/)
      flash.now[:alert] = 'This is not a URL we know how to import. <a href="#" class="feed-type-info">Click here</a> for information about available feed types.'
      render action: 'new'
    else
      flash.now[:alert] = 'Failed to create feed'
      render action: 'new'
    end
  end

  def update
    @event_feed.assign_attributes(event_feed_params)

    if !authorized_for_event_feed?
      redirect_to business_content_event_imports_path, notice: "Unauthorized to update this event feed."
      return
    end

    upload_file

    if @event_feed.save
      redirect_to business_content_event_imports_path, notice: "This feed has been updated and queued for processing. Once the import is finished, we'll send an email notification."
    elsif @event_feed.errors.full_messages.join.match(/unable to parse/)
      flash.now[:alert] = 'This is not a URL we know how to import. <a href="#" class="feed-type-info">Click here</a> for information about available feed types.'
      render action: 'new'
    else
      flash.now[:alert] = 'Failed to update feed'
      render action: 'edit'
    end
  end

  def destroy
    @event_feed.destroy

    redirect_to business_content_event_imports_path, notice: 'Feed destroyed'
  end

  private

  def authorized_for_event_feed?
    EventFeed.for_business(@business).include?(@event_feed)
  end

  def upload_file
    return unless params[:event_feed][:upload].present?
    upload = S3Service.upload(params[:event_feed][:upload].tempfile, acl: :public_read)
    @event_feed.url = upload.public_url.to_s
  end

  def event_feed_params
    params.require(:event_feed).permit(:name, :url, :business_id, :time_zone, location_attributes: [
                                       :id, :name, :email, :street1, :street2, :city, :state,
                                       :zip_code, :phone_number, :business_id, :_destroy ])
  end
end
