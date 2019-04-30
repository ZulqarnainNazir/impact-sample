class Listing::ListingsController < ApplicationController
  layout "listing"

  include ContentSearchConcern
  include EventSearchConcern

  helper_method :get_events

  before_action do
    @business = Business.listing_lookup(params[:lookup])

    # TODO - Get rid of this.
    # if @business.events.any?
    #   @calendar_widget = CalendarWidget.new         # empty "fake" calendar widget in order to display business events
    # end

    # TODO - Move to variables past to partial.
    @truncate_rev = true
    @masonry = true #tells content partials to use masonry format


    # TODO - Where should this live?
    @og_title = @business.name
    if @business.location.city.present? || @business.location.state.present?
      @og_title = @og_title + ','
      if @business.location.city.present?
        @og_title = @og_title + ' ' + @business.location.city
      end
      if @business.location.state.present?
        @og_title = @og_title + ' ' + @business.location.state
      end
    end

  end

  def index

    if params[:content_types]
        @content_types = params[:content_types]
    else
      @content_types = "QuickPost Offer Job Gallery BeforeAfter Post".split
    end

    @posts = get_content(business: @business, content_types: @content_types, order: 'desc', page: params[:page], per_page: 12)

    @reviews = @business.reviews.published.order(reviewed_at: :desc).page(params[:page]).per(20)


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
  	@masonry = true #tells content partials to use masonry format

  end

  # def overview
  # end

  def local_connections
    @directories = @business.directory_widgets
  end

  private

end
