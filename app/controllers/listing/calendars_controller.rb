class Listing::CalendarsController < ApplicationController
  layout "listing"

  include ApplicationHelper
  include ContentSearchConcern
  include EventSearchConcern

  before_action do
    @business = Business.listing_lookup(params[:lookup])
    @calendar_widgets = @business.calendar_widgets

    default = {:id => @calendar_widgets.first.id}
    if params[:calendar_widget].nil?
      params[:calendar_widget] = default
    end
    @calendar_widget = CalendarWidget.find(params[:calendar_widget][:id])

    # @content_feed_widget = ContentFeedWidget.new  # empty "fake" content widget in order to display business content
    # @content_feed_widget.business = @business
    # @content_feed_widget.max_items = 12
    #Does this content types params need to be here?
    # params[:content_types] = ["QuickPost","Gallery", "BeforeAfter", "Offer", "Job" ,"CustomPost",""]
    # @posts = get_events(business: @content_feed_widget.business, embed: @content_feed_widget, content_category_ids: @content_feed_widget.content_category_ids.map(&:to_i), content_tag_ids: @content_feed_widget.content_tag_ids.map(&:to_i), page: params[:page], per_page: @content_feed_widget.max_items)
    @posts = get_events(business: @business, page: params[:page], per_page: 12)

  end

  before_action only: [:index] do
    default = {:id => @calendar_widgets.first.id}
    if params[:calendar_widget].nil?
      params[:calendar_widget] = default
    end
    @calendar_widget = CalendarWidget.find(params[:calendar_widget][:id])
  end

  def index

    @start_date_parsed = Date.strptime(params[:start_date], '%m/%d/%Y') rescue Date.parse(params[:start_date]) rescue nil
    @start_date = @start_date_parsed.strftime('%F') rescue ''
    @end_date = ''

    @event_kinds = params[:filter_kinds] ? params[:filter_kinds] : []

    @events = get_events(business: @business, embed: @calendar_widget, query: params[:blog_search], kinds: @event_kinds, page: params[:page], per_page: 12, start_date: @start_date, end_date: @end_date)

  end

  def show
    @calendar_widget = @business.calendar_widgets.find(params[:id])

    @start_date_parsed = Date.strptime(params[:start_date], '%m/%d/%Y') rescue Date.parse(params[:start_date]) rescue nil
    @start_date = @start_date_parsed.strftime('%F') rescue ''
    @end_date = ''

    @event_kinds = params[:filter_kinds] ? params[:filter_kinds] : []

    @events = get_events(business: @business, embed: @calendar_widget, query: params[:blog_search], kinds: @event_kinds, page: params[:page], per_page: 12, start_date: @start_date, end_date: @end_date)

  end


end
