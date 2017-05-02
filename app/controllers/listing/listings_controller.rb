require 'search_helper'
class Listing::ListingsController < ApplicationController
  include SearchHelper
  helper_method :events, :posts
  before_action except: :index do
    @business = Business.listing_lookup(params[:lookup])
  end

  def index

  end

  #CONTENT TYPES
  def content_type
    if params[:content] == 'before_after'
      @post = @business.before_afters.find_by(slug: params[:content_type])
    elsif params[:content] == 'event'
      @post = @business.events.find(params[:content_type])
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
    end
  end
  
  def listing
  	@masonry = true #tells content partials to use masonry format

  	#code below is overriding code found in search_helper
  	@content_types_all = "Event Gallery BeforeAfter Offer Post".split
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

  private

end