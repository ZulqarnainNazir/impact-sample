require 'search_helper'
class Website::BaseController < ApplicationController
  include SearchHelper

  helper_method :events, :posts, :order_the_events, :blog_search_base, :events_organized_desc, :get_content_types

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

  #methods used for search @ /blog used to be here. they were removed to
  #search_helper 4.13.17 for use in other controllers (e.g., listings)

end
