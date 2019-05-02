class Widgets::CalendarWidgetsController < Widgets::BaseController
  def index
    @calendar_widget = CalendarWidget.where(:uuid => params[:uuid]).first
    @business = @calendar_widget.business
    # get_content_types(nil, @calendar_widget)

    @start_date_parsed = Date.strptime(params[:start_date], '%m/%d/%Y') rescue Date.parse(params[:start_date]) rescue nil

    # We use an explicit view if given as a param. Otherwise, we use List for searches and default otherwise
    if params[:view] == 'agenda' || params[:view] == 'grid' || params[:view] == 'list'
      @container_view = params[:view]
    elsif params[:blog_search].present? || params[:start_date].present?
      @container_view = 'list'
    else
      @container_view = @calendar_widget.default_view
    end

    # Pick a tab to view in Agenda
    if params[:view_date].present?
      @agenda_view_date = Date.parse(params[:view_date]) rescue Date.today
    elsif @start_date_parsed.present?
      @agenda_view_date = @start_date_parsed
    else
      @agenda_view_date = Date.today
    end

    @monday = (@agenda_view_date-1) - (@agenda_view_date-1).wday + 1

    # Are we looking for events starting on a particular day?
    if @container_view == 'agenda'
      @start_date = @agenda_view_date.strftime('%F')
      @end_date = @start_date
    else
      @start_date = @start_date_parsed.strftime('%F') rescue ''
      @end_date = ''
    end

    # Are we filtering any event kinds?
    if @calendar_widget.filter_kinds.compact.present?
      @filterable_kinds = @calendar_widget.filter_kinds.compact
    else
      @filterable_kinds = [0, 1, 2]
    end

    if params[:filter_kinds].present?
      @filter_kinds = params[:filter_kinds].map { |s| s.to_i }.select { |e| @filterable_kinds.include?(e) }
    else
      @filter_kinds = []
    end

    @sources = EventFeed.where(business_id: @calendar_widget.business.id).pluck(:name, :id).uniq

    @events = get_events(business: @calendar_widget.business, embed: @calendar_widget, query: params[:blog_search], kinds: @filter_kinds, page: params[:page], per_page: @calendar_widget.max_items, start_date: @start_date, end_date: @end_date, feed_id: (params[:feed_id].present? ? params[:feed_id] : ''))

    # For Agenda view, we also need a count of events on other days of the week
    if @container_view == 'agenda' && params[:start_date].present? || params[:blog_search].present?

      @week_events = get_events(business: @calendar_widget.business, embed: @calendar_widget, query: params[:blog_search], kinds: @filter_kinds, page: 1, per_page: 800, start_date: @monday.strftime('%F'), end_date: (@monday + 6).strftime('%F'), feed_id: (params[:feed_id].present? ? params[:feed_id] : ''))

      @counts = [\
          @week_events.count{|x|x.occurs_on == @monday + 0},
          @week_events.count{|x|x.occurs_on == @monday + 1},
          @week_events.count{|x|x.occurs_on == @monday + 2},
          @week_events.count{|x|x.occurs_on == @monday + 3},
          @week_events.count{|x|x.occurs_on == @monday + 4},
          @week_events.count{|x|x.occurs_on == @monday + 5},
          @week_events.count{|x|x.occurs_on == @monday + 6}]
    else
      @week_events = []
      @counts = [0, 0, 0, 0, 0, 0, 0]
    end

    # TODO - What the heck does this do in the context of Calendar Widget?
    if @content_feed.blank?
      return false
    end

    if !params[:widget_layout].blank?
      @widget.layout = params[:widget_layout]
    end

  end

  def show
    @calendar_widget = CalendarWidget.where(:uuid => params[:uuid]).first
    if @calendar_widget.blank?
      return false
    end
    @page = @calendar_widget.business.owned_companies.find(params[:business_id])


  end
end
