class Website::BaseController < ApplicationController
  include ContentSearchConcern
  include EventSearchConcern

  before_action do
    if !params[:uuid].blank?
      @content_feed_widget = ContentFeedWidget.where(:uuid => params[:uuid]).first
    end
    if @content_feed_widget
      self.class.layout "website_embed"
    else
      self.class.layout 'website'
    end
  end

  after_action do
    if !params[:uuid].blank?
      @content_feed_widget = ContentFeedWidget.where(:uuid => params[:uuid]).first
    end
    if @content_feed_widget
      allow_iframe
    end
  end

  before_action do
    @masonry = true
  end

  before_action do
    @webhost = Webhost.find_by_name(request.host)

    if @webhost && @webhost.website
      @website = @webhost.website
    elsif !@webhost && request.host.match(Rails.application.secrets.host)
      @website = Website.find_by_subdomain(request.subdomains.first)
    end

    if !@website
      render 'website/application/website_not_found', layout: 'blank', status: 404
    elsif @website.webhost.try(:primary?) && @webhost != @website.webhost
      redirect_to host: @website.webhost.name
    end
  end



  before_action do
    @business = @website.business
    @location = @business.location

    if @business.free? && request.path == '/'
      render template: 'website/application/free_webpage'
    elsif @business.free?
      redirect_to website_root_path, status: 302
    end
  end

  # before_action do
  #
  #   @page = @website.webpages.custom.find_by_pathname!(params[:id]) if @website
  #   if @website && @page && @page.groups.where(type: 'CalendarGroup').first.present?
  #     @calendar_widget = CalendarWidget.find_by(id: @page.groups.where(type: 'CalendarGroup').first.blocks.first.widget_id)
  #   else
  #     @calendar_widget = CalendarWidget.where(:uuid => params[:uuid]).first
  #   end
  #
  #   if @calendar_widget
  #
  #     @start_date_parsed = Date.strptime(params[:start_date], '%m/%d/%Y') rescue Date.parse(params[:start_date]) rescue nil
  #
  #     # We use an explicit view if given as a param. Otherwise, we use List for searches and default otherwise
  #     if params[:view] == 'agenda' || params[:view] == 'grid' || params[:view] == 'list'
  #       @container_view = params[:view]
  #     elsif params[:blog_search].present? || params[:start_date].present?
  #       @container_view = 'list'
  #     else
  #       @container_view = @calendar_widget.default_view
  #     end
  #
  #     # Pick a tab to view in Agenda
  #     if params[:view_date].present?
  #       @agenda_view_date = Date.parse(params[:view_date]) rescue Date.today
  #     elsif @start_date_parsed.present?
  #       @agenda_view_date = @start_date_parsed
  #     else
  #       @agenda_view_date = Date.today
  #     end
  #
  #     @monday = (@agenda_view_date-1) - (@agenda_view_date-1).wday + 1
  #
  #     # Are we looking for events starting on a particular day?
  #     if @container_view == 'agenda'
  #       @start_date = @agenda_view_date.strftime('%F')
  #       @end_date = @start_date
  #     else
  #       @start_date = @start_date_parsed.strftime('%F') rescue ''
  #       @end_date = ''
  #     end
  #
  #     # Are we filtering any event kinds?
  #     if @calendar_widget.filter_kinds.compact.present?
  #       @event_kinds = @calendar_widget.filter_kinds.compact
  #     else
  #       @event_kinds = [0, 1, 2]
  #     end
  #
  #     if params[:filter_kinds].present?
  #       @filter_kinds = params[:filter_kinds].map { |s| s.to_i }.select { |e| @event_kinds.include?(e) }
  #     else
  #       @filter_kinds = @event_kinds
  #     end
  #
  #     @events = get_events(business: @calendar_widget.business, embed: @calendar_widget, query: params[:blog_search], kinds: @filter_kinds, page: params[:page], per_page: @calendar_widget.max_items, start_date: @start_date, end_date: @end_date)
  #
  #
  #     # For Agenda view, we also need a count of events on other days of the week
  #     if @container_view == 'agenda' && params[:start_date].present? || params[:blog_search].present?
  #
  #       @week_events = get_events(business: @calendar_widget.business, embed: @calendar_widget, query: params[:blog_search], page: 1, per_page: 800, start_date: @monday.strftime('%F'), end_date: (@monday + 6).strftime('%F'))
  #
  #       @counts = [\
  #           @week_events.count{|x|x.occurs_on == @monday + 0},
  #           @week_events.count{|x|x.occurs_on == @monday + 1},
  #           @week_events.count{|x|x.occurs_on == @monday + 2},
  #           @week_events.count{|x|x.occurs_on == @monday + 3},
  #           @week_events.count{|x|x.occurs_on == @monday + 4},
  #           @week_events.count{|x|x.occurs_on == @monday + 5},
  #           @week_events.count{|x|x.occurs_on == @monday + 6}]
  #     else
  #       @week_events = []
  #       @counts = [0, 0, 0, 0, 0, 0, 0]
  #     end
  #   end
  #
  # end

  before_action do

    if @website.content_blog_sidebar?
      @sidebar_content = get_content(business: @business, content_types: ["QuickPost", "Post", "Offer", "Job", "Gallery", "BeforeAfter"], per_page: '4')
    end

    if @website.events_sidebar?
      @sidebar_events = get_events(business: @business, per_page: 4)
    end

  end

  before_action do

    if @website.footer_block
      @footer_content = get_content(business: @business, content_types: ["QuickPost", "Gallery", "BeforeAfter", "Post"], content_category_ids: Array(@business.website.footer_block.left_category_ids), per_page: @business.website.footer_block.left_number_of_feed_items.to_i)
      @footer_events = get_events(business: @business, content_category_ids: Array(@business.website.footer_block.right_category_ids), per_page: @business.website.footer_block.right_number_of_feed_items.to_i)
    end

  end

  rescue_from 'ActionController::InvalidAuthenticityToken' do |exception|
    render 'website/application/webpage_unprocessable_entity', layout: 'blank', status: 422
  end

  rescue_from 'ActiveRecord::RecordNotFound' do |exception|
    redirect = @website.redirects.find_by_from_path(request.path)

    if redirect
      redirect_to redirect.to_path, status: 301
    else
      render 'website/application/webpage_not_found', status: 404
    end
  end

  def allow_iframe
    response.headers.except! 'X-Frame-Options'
  end

  private

end
