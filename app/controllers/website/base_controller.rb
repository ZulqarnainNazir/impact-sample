class Website::BaseController < ApplicationController
  helper_method :events, :posts, :order_the_events, :blog_search_base, :events_organized_desc, :get_content_types
  layout 'website'

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

  private

  def order_the_events(array)
    #purpose of method is to take an array containing various content types
    #pluck the events, and rearrange them from earliest to latest
    #while maintaining the original integrity of order
    events = []
    position = []
    array.each_with_index do |n, index|
      if n.class.name == "Event"
         events << n
         position << index
      end
    end

    if events.count >= 2
      events = events.reverse
      position = position.reverse

      events.each do |n|
        place = position.pop
        array.insert(place, n)
        array.delete_at(place + 1)
      end
    end

    return array

  end

  def events(business, page: 1, limit: 4)
    business.events.
      where('occurs_on >= ?', Time.zone.now).
      order(occurs_on: :asc).
      page(page).
      per(limit)
  end

  def events_organized_desc(business, page: 1, limit: 4)
    business.events.
      where('occurs_on >= ?', Time.zone.now).
      order(occurs_on: :desc).
      page(page).
      per(limit)
  end

  def posts(business, content_types: [], content_category_ids: [], content_tag_ids: [], page: 1, limit: 4)
    ContentBlogSearch.new(
      business, 
      '', 
      content_types: content_types, 
      content_category_ids: content_category_ids, 
      content_tag_ids: content_tag_ids
    ).search.page(page).per(limit).records
  end

  def blog_search_base(business, search_string, content_types: [], content_category_ids: [], content_tag_ids: [], page: 1, limit: 4)
    ContentBlogSearch.new(
      business, 
      search_string, 
      content_types: content_types,
      content_category_ids: content_category_ids, 
      content_tag_ids: content_tag_ids
    ).search.page(page).per(limit).records
  end

  #get_content_types method is a critical method for 
  #getting the right content types to show, as scoped by type. 
  #e.g., if the homepage is scoped to show events and before and after, 
  #this method should be used in the
  #home_pages_controller.
  def get_content_types(group_type, page_instance_variable)
    @content_types_all = page_instance_variable.groups.where(type: group_type).first.blocks.first.content_types.split
    if !params[:content_types].present?
      params[:content_types] = @content_types_all
    elsif params[:content_types].present?
      @content_types = params[:content_types]
    end
  end

end
