require 'search_helper'
class Listing::ContentController < ApplicationController
  layout "listing"

  include SearchHelper
  include ContentSearchConcern

  helper_method :events, :posts

  before_action :index do
    @business = Business.listing_lookup(params[:lookup])
    @content_feed_widget = ContentFeedWidget.new  # empty "fake" content widget in order to display business content
    @content_feed_widget.business = @business
    @content_feed_widget.max_items = 12

    # params[:content_types] = ["QuickPost","Gallery", "BeforeAfter", "Offer", "Job" ,"CustomPost", "Post",""]
    # @posts = content_feed_widget_base(@content_feed_widget, @content_feed_widget.business, content_types: params[:content_types], content_category_ids: @content_feed_widget.content_category_ids.map(&:to_i), content_tag_ids: @content_feed_widget.content_tag_ids.map(&:to_i), page: params[:page], limit: @content_feed_widget.max_items)
    params[:content_types] = ["QuickPost", "Gallery", "BeforeAfter", "Offer", "Job", "Post"]
    @posts = get_content(@content_feed_widget.business, @content_feed_widget, '', params[:content_types], @content_feed_widget.content_category_ids.to_s.split(' ').map(&:to_i), @content_feed_widget.content_tag_ids.to_s.split(' ').map(&:to_i), 'desc', params[:page], @content_feed_widget.max_items)

  end

  def index

    @business = Business.listing_lookup(params[:lookup])
    @masonry = true #tells content partials to use masonry format
    #params[:content_types] = ["QuickPost","Gallery", "BeforeAfter", "Offer", "Job" ,"CustomPost",""]

    #code below is overriding code found in search_helper
    @content_types_all = "QuickPost Gallery BeforeAfter Offer Post Job CustomPost".split
    if !params[:content_types].present? && !@content_types_all.nil?
      params[:content_types] = @content_types_all
    elsif params[:content_types].present?
      @content_types = params[:content_types]
    end
    if @content_types_all.present?
      prune_content_types_all(@content_types_all)
    end
    #end of overriding-code

  end

  #CONTENT TYPES
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

  def quick_post
    @post = @business.quick_posts.find_by(slug: params[:content_type])
  end

  def event
    @event = @business.events.find_by(id: params[:content_type])
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
=begin
  	@masonry = true #tells content partials to use masonry format

  	#code below is overriding code found in search_helper
  	@content_types_all = "Event Gallery BeforeAfter Offer Post Job".split
    if !params[:content_types].present? && !@content_types_all.nil?
      params[:content_types] = @content_types_all
    elsif params[:content_types].present?
      @content_types = params[:content_types]
    end
    if @content_types_all.present?
      prune_content_types_all(@content_types_all)
    end
    #end of overriding-code
=end
  end

  private

end
