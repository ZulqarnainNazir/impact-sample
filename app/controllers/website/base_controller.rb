class Website::BaseController < ApplicationController
  layout 'website'

  helper_method :sidebar_feed_items, :sidebar_events

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

    if @business.free?
      render 'website/application/website_not_found', layout: 'blank', status: 404
    end
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

  def sidebar_feed_items(limit = 4)
    @feed_items = ContentBlogSearch.new(@business).search.page(1).per(limit).records
  end

  def sidebar_events(limit = 4)
    @business.events.
      where('occurs_on >= ?', Time.zone.now).
      order(occurs_on: :asc).
      page(params[:page]).
      per(limit)
  end
end
