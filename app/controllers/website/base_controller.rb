class Website::BaseController < ApplicationController
  helper_method :events, :posts
  layout 'website'

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

  def events(business, page: 1, limit: 4)
    business.events.
      where('occurs_on >= ?', Time.zone.now).
      order(occurs_on: :asc).
      page(page).
      per(limit)
  end

  def posts(business, content_category_ids: [], content_tag_ids: [], page: 1, limit: 4)
    ContentBlogSearch.new(business, '', content_category_ids: content_category_ids, content_tag_ids: content_tag_ids).search.page(page).per(limit).records
  end
end
