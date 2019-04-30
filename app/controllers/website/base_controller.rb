# require 'search_helper'
class Website::BaseController < ApplicationController
  include ContentSearchConcern
  include EventSearchConcern

  # TODO - Remove Helper methods after these methods are moved to their coresponding controllers
  helper_method :get_content, :get_events

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

  #methods used for search @ /blog used to be here. they were removed to
  #search_helper 4.13.17 for use in other controllers (e.g., listings)

end
