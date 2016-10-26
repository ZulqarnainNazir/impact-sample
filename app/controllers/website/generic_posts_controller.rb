class Website::GenericPostsController < Website::BaseController
  def show
    @post = @business.posts.find_by_id_and_slug(params[:id], params[:slug])
    if @post
      render 'website/posts/show'
      return
    end

    @quick_post = @business.quick_posts.find_by_id_and_slug(params[:id], params[:slug])

    if @quick_post
      render 'website/quick_posts/show'
      return
    end
    
    @event = @business.events.joins(:event_definition).where(id: params[:id], event_definitions: { slug: params[:slug] }).first
    if @event
      port = ":#{request.try(:port)}" if request.port
      host = website_host @business.website
      post_path = website_event_path
      @preview_url = @event.event_definition.published_status != false ? host + port + post_path : [:website, :generic_post, :preview, :type => "events", only_path: false, :host => website_host(@business.website), :id => @event.event_definition.id]

      @upcoming_events = @event.event_definition.events.
        where.not(id: @event.id).
        where('occurs_on >= ?', Time.zone.now).
        order(occurs_on: :asc).
        page(1).
        per(4)
      render 'website/events/show'
      return
    end

    @offer = @business.offers.find_by_id_and_slug(params[:id], params[:slug])

    if @offer
      render 'website/offers/show'
      return
    end

    @before_after = @business.before_afters.find_by_id_and_slug(params[:id], params[:slug])
    if @before_after
      render 'website/before_afters/show'
      return
    end

    @gallery = @business.galleries.find(params[:id])
    if @gallery && !params[:image_id]
      render 'website/galleries/show'
      return
    end

    @gallery_image = GalleryImage.find(params[:image_id])
    if @gallery_image
      @gallery = @gallery_image.gallery
      render 'website/gallery_images/show'
      return
    end


    raise ActiveRecord::RecordNotFound
  end


  def preview

    case params[:type]
    when "before_afters"
      @before_after = @business.before_afters.find(params[:id])
    when "posts"
      @post = @business.posts.find(params[:id])
    when "quick_posts"
      @quick_post = @business.quick_posts.find(params[:id])
    when "posts"
      @post = @business.posts.find(params[:id])
    when "quick_posts"
      @quick_post = @business.quick_posts.find(params[:id])
    when "events"
      @event = @business.events.joins(:event_definition).where(id: params[:id]).first
      if @event
        @upcoming_events = @event.event_definition.events.
          where.not(id: @event.id).
          where('occurs_on >= ?', Time.zone.now).
          order(occurs_on: :asc).
          page(1).
          per(4)
      end
    when "offers"
      @offer = @business.offers.find(params[:id])
    when "galleries"
      @gallery = @business.galleries.find(params[:id])
    when "gallery_images"
      @gallery = @business.galleries.find(params[:gallery_id])
      @gallery_image = GalleryImage.find(params[:id])
    else
      raise ActiveRecord::RecordNotFound
    end
    @preview = true
    render "website/#{params[:type]}/show"
  end
end
