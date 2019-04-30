# require 'search_helper'
class Listing::ListingsController < ApplicationController
  layout "listing"

  include ContentSearchConcern
  include EventSearchConcern

  helper_method :get_events, :get_content

  before_action do
    @business = Business.listing_lookup(params[:lookup])

    if @business.events.any?
      @calendar_widget = CalendarWidget.new         # empty "fake" calendar widget in order to display business events
    end

    @content_feed_widget = ContentFeedWidget.new  # empty "fake" content widget in order to display business content
    @content_feed_widget.business = @business
    @content_feed_widget.max_items = 12

    if params[:content_types]
        @content_types = params[:content_types]
    else
      @content_types = "QuickPost Offer Job Gallery BeforeAfter Post".split
    end

    @posts = get_content(business: @content_feed_widget.business, embed: @content_feed_widget, content_types: @content_types, content_category_ids: @content_feed_widget.content_category_ids, content_tag_ids: @content_feed_widget.content_tag_ids, order: 'desc', page: params[:page], per_page: @content_feed_widget.max_items)

    @truncate_rev = true
    @reviews = @business.reviews.published.order(reviewed_at: :desc).page(params[:page]).per(20)

    @masonry = true #tells content partials to use masonry format

    #code below is overriding code found in search_helper
    # @content_types_all = "QuickPost Gallery BeforeAfter Offer Post Job CustomPost".split
    # if !params[:content_types].present? && !@content_types_all.nil?
    #   params[:content_types] = @content_types_all
    # elsif params[:content_types].present?
    #   @content_types = params[:content_types]
    # end
    # if @content_types_all.present?
    #   prune_content_types_all(@content_types_all)
    # end
    #end of overriding-code

    @og_title = @business.name

    if @business.location.city.present? || @business.location.state.present?
      @og_title = @og_title + ','
    end

    if @business.location.city.present?
      @og_title = @og_title + ' ' + @business.location.city
    end

    if @business.location.state.present?
      @og_title = @og_title + ' ' + @business.location.state
    end

  end

  # def setup_content_types
  #   @masonry = true #tells content partials to use masonry format
  #
  #   #code below is overriding code found in search_helper
  #   @content_types_all = "Event Gallery BeforeAfter Offer Post Job".split
  #   if !params[:content_types].present? && !@content_types_all.nil?
  #     params[:content_types] = @content_types_all
  #   elsif params[:content_types].present?
  #     @content_types = params[:content_types]
  #   end
  #   if @content_types_all.present?
  #     prune_content_types_all(@content_types_all)
  #   end
  #   #end of overriding-code
  # end

  def index

  end

  #CONTENT TYPES
  # def content_type
  #   if params[:content] == 'before_after'
  #     @post = @business.before_afters.find_by(slug: params[:content_type])
  #   elsif params[:content] == 'event'
  #     @post = @business.events.find(params[:content_type])
  #     @upcoming_events = @post.event_definition.events.
  #       where.not(id: @post.id).
  #       where('occurs_on >= ?', Time.zone.now).
  #       order(occurs_on: :asc).
  #       page(1).
  #       per(4)
  #   elsif params[:content] == 'event_definition'
  #     @post = @business.event_definitions.find(params[:content_type])
  #   elsif params[:content] == 'gallery'
  #     @post = @business.galleries.find_by(slug: params[:content_type])
  #   elsif params[:content] == 'offer'
  #     @post = @business.offers.find_by(slug: params[:content_type])
  #   elsif params[:content] == 'post'
  #     @post = @business.posts.find_by(slug: params[:content_type])
  #   elsif params[:content] == 'quick_post'
  #     @post = @business.quick_posts.find_by(slug: params[:content_type])
  #   elsif params[:content] == 'job'
  #     @post = @business.jobs.find_by(slug: params[:content_type])
  #   end
  # end

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
  	@masonry = true #tells content partials to use masonry format

  	# #code below is overriding code found in search_helper
  	# @content_types_all = "Event Gallery BeforeAfter Offer Post Job".split
    # if !params[:content_types].present? && !@content_types_all.nil?
    #   params[:content_types] = @content_types_all
    # elsif params[:content_types].present?
    #   @content_types = params[:content_types]
    # end
    # if @content_types_all.present?
    #   prune_content_types_all(@content_types_all)
    # end
    # #end of overriding-code
  end

  def overview
  end

  def local_connections
    @directories = @business.directory_widgets
  end

  private

end
