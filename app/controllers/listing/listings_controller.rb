class Listing::ListingsController < ApplicationController
  layout "listing"

  include ContentSearchConcern
  include EventSearchConcern

  before_action do
    @business = Business.listing_lookup(params[:lookup])

    # TODO - Move to variables and pass to partial.
    @truncate_rev = true
    @masonry = true

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

    # TODO - Why does this not work if below is in index....works locally but not on heroku...
    if params[:content_types]
      @content_types = params[:content_types]
    else
      @content_types = ALL_CONTENT_TYPES
    end

    @posts = get_content(business: @business, content_types: @content_types, page: params[:page], per_page: 12)

    @reviews = @business.reviews.published.order(reviewed_at: :desc).page(params[:page]).per(20)

    @start_date_parsed = Date.strptime(params[:start_date], '%m/%d/%Y') rescue Date.parse(params[:start_date]) rescue nil
    @start_date = @start_date_parsed.strftime('%F') rescue ''
    @end_date = ''

    @event_kinds = params[:filter_kinds] ? params[:filter_kinds] : []

    @events = get_events(business: @business, query: params[:blog_search], kinds: @event_kinds, page: params[:page], per_page: 12, start_date: @start_date, end_date: @end_date)

    @products = @business.products
  end

  def index


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

  def listing
    # TODO - Move to variables and pass to partial.
  	@masonry = true #tells content partials to use masonry format

  end

  def local_connections
    @directories = @business.directory_widgets
  end

  private

end
