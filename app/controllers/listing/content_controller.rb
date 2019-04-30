# require 'search_helper'
class Listing::ContentController < ApplicationController
  layout "listing"

  include ContentSearchConcern
  include EventSearchConcern

  helper_method :get_events

  before_action :index do
    @business = Business.listing_lookup(params[:lookup])
    @content_feed_widget = ContentFeedWidget.new  # empty "fake" content widget in order to display business content
    @content_feed_widget.business = @business
    @content_feed_widget.max_items = 12

    if params[:content_types]
        @content_types = params[:content_types]
    else
      @content_types = "QuickPost Offer Job Gallery BeforeAfter Post".split
    end

    @posts = get_content(business: @content_feed_widget.business, embed: @content_feed_widget, content_types: @content_types, content_category_ids: @content_feed_widget.content_category_ids, content_tag_ids: @content_feed_widget.content_tag_ids, order: 'desc', page: params[:page], per_page: @content_feed_widget.max_items)

  end

  def index

    @business = Business.listing_lookup(params[:lookup])
    @masonry = true #tells content partials to use masonry format

  end

  def gallery_image #in routes, a child of content_type (specficially, gallery)
    @gallery = @business.galleries.find_by(slug: params[:content_type])
    @gallery_image = GalleryImage.find(params[:gallery_image])
    if @gallery_image == GalleryImage.find(params[:gallery_image])
      render 'gallery_image'
      return
    else
      raise ActiveRecord::RecordNotFound
    end
  end

  #TODO - THis is dumb - I think this will be fixed by seans routes work
  def event
    @event = @business.events.find_by(id: params[:content_type])
  end

  def listing

  end

  private

end
