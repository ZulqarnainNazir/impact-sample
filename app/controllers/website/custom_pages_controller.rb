class Website::CustomPagesController < Website::BaseController
  before_action do
    @page = @website.webpages.custom.find_by_pathname!(params[:id])

    if params[:content_types]
        @content_types = params[:content_types]
    elsif @page.groups.where(type: 'BlogFeedGroup').first.try(:blocks)
      # TODO - Below returns wrong types so should update source to pass correct types (remove event, change custompost to post) so don't need the delete and add functions
      @content_types = @page.groups.where(type: 'BlogFeedGroup').first.blocks.first.content_types.split
      @content_types.delete('Event')
      @content_types.delete('CustomPost')
      @content_types << 'Post'
    else
      @content_types = "QuickPost Offer Job Gallery BeforeAfter Post".split
    end

    @content_types_all = "QuickPost Offer Job Gallery BeforeAfter Post".split

  end

  def show

    # if @page.groups.where(type: 'CalendarGroup').first.present?
    #   @calendar_widget = CalendarWidget.find_by(id: @page.groups.where(type: 'CalendarGroup').first.blocks.first.widget_id)
    # else
    #   @calendar_widget = CalendarWidget.where(:uuid => params[:uuid]).first
    #   @hw = @calendar_widget
    # end
    #
    # @start_date_parsed = Date.strptime(params[:start_date], '%m/%d/%Y') rescue Date.parse(params[:start_date]) rescue nil
    #
    # # We use an explicit view if given as a param. Otherwise, we use List for searches and default otherwise
    # if params[:view] == 'agenda' || params[:view] == 'grid' || params[:view] == 'list'
    #   @container_view = params[:view]
    # elsif params[:blog_search].present? || params[:start_date].present?
    #   @container_view = 'list'
    # else
    #   @container_view = @calendar_widget.default_view
    # end
    #
    # # Pick a tab to view in Agenda
    # if params[:view_date].present?
    #   @agenda_view_date = Date.parse(params[:view_date]) rescue Date.today
    # elsif @start_date_parsed.present?
    #   @agenda_view_date = @start_date_parsed
    # else
    #   @agenda_view_date = Date.today
    # end
    #
    # @monday = (@agenda_view_date-1) - (@agenda_view_date-1).wday + 1
    #
    # # Are we looking for events starting on a particular day?
    # if @container_view == 'agenda'
    #   @start_date = @agenda_view_date.strftime('%F')
    #   @end_date = @start_date
    # else
    #   @start_date = @start_date_parsed.strftime('%F') rescue ''
    #   @end_date = ''
    # end
    #
    # # Are we filtering any event kinds?
    # if @calendar_widget.filter_kinds.compact.present?
    #   @event_kinds = @calendar_widget.filter_kinds.compact
    # else
    #   @event_kinds = [0, 1, 2]
    # end
    #
    # if params[:filter_kinds].present?
    #   @filter_kinds = params[:filter_kinds].map { |s| s.to_i }.select { |e| @event_kinds.include?(e) }
    # else
    #   @filter_kinds = @event_kinds
    # end
    #
    # @events = get_events(business: @calendar_widget.business, embed: @calendar_widget, query: params[:blog_search], kinds: @filter_kinds, page: params[:page], per_page: @calendar_widget.max_items, start_date: @start_date, end_date: @end_date)
    #
    #
    # # For Agenda view, we also need a count of events on other days of the week
    # if @container_view == 'agenda' && params[:start_date].present? || params[:blog_search].present?
    #
    #   @week_events = get_events(business: @calendar_widget.business, embed: @calendar_widget, query: params[:blog_search], page: 1, per_page: 800, start_date: @monday.strftime('%F'), end_date: (@monday + 6).strftime('%F'))
    #
    #   @counts = [\
    #       @week_events.count{|x|x.occurs_on == @monday + 0},
    #       @week_events.count{|x|x.occurs_on == @monday + 1},
    #       @week_events.count{|x|x.occurs_on == @monday + 2},
    #       @week_events.count{|x|x.occurs_on == @monday + 3},
    #       @week_events.count{|x|x.occurs_on == @monday + 4},
    #       @week_events.count{|x|x.occurs_on == @monday + 5},
    #       @week_events.count{|x|x.occurs_on == @monday + 6}]
    # else
    #   @week_events = []
    #   @counts = [0, 0, 0, 0, 0, 0, 0]
    # end

  end

end
