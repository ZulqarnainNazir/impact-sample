# require 'search_helper'
class Listing::ContentController < ApplicationController
  layout "listing"

  include ContentSearchConcern
  include EventSearchConcern

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

  #CONTENT TYPES
  # TODO - This has to do with weird routes for lookup that sean is working on.
  def content_type
    if params[:content] == 'before_after'
      @post = @business.before_afters.find_by(slug: params[:content_type])
    elsif params[:content] == 'event'
      @post = @business.events.find(params[:content_type])
      @upcoming_events = @post.event_definition.events.
        where.not(id: @post.id).
        where('occurs_on >= ?', Time.zone.now).
        order(occurs_on: :asc).
        page(1).
        per(4)
    elsif params[:content] == 'event_definition'
      @post = @business.event_definitions.find(params[:content_type])
    elsif params[:content] == 'gallery'
      @post = @business.galleries.find_by(slug: params[:content_type])
    elsif params[:content] == 'offer'
      @post = @business.offers.find_by(slug: params[:content_type])
    elsif params[:content] == 'post'
      @post = @business.posts.find_by(slug: params[:content_type])
    elsif params[:content] == 'quick_post'
      @post = @business.quick_posts.find_by(slug: params[:content_type])
    elsif params[:content] == 'job'
      @post = @business.jobs.find_by(slug: params[:content_type])
    end
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

  def quick_post
    @post = @business.quick_posts.find_by(slug: params[:content_type])
  end

  def before_after
    @post = @business.before_afters.find_by(slug: params[:content_type])
  end

  def offer
    @post = @business.offers.find_by(slug: params[:content_type])
  end

  def post
    @post = @business.posts.find_by(slug: params[:content_type])
  end

  def job
    @post = @business.jobs.find_by(slug: params[:content_type])
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

  def listing

  end

  private

end
