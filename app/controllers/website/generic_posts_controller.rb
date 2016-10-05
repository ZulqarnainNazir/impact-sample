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
      @upcoming_events = @event.event_definition.events.
        where.not(id: @event.id).
        where('occurs_on >= ?', Time.zone.now).
        order(occurs_on: :asc).
        page(1).
        per(4)
      render 'website/events/show'
      return
    end

    @gallery = @business.galleries.find_by_id_and_slug(params[:id], params[:slug])

    if @gallery
      render 'website/galleries/show'
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
          binding.pry
      @before_after = @business.before_afters.find(params[:id])
          binding.pry
    when "posts"
          binding.pry
      @post = @business.posts.find(params[:id])
          binding.pry
    when "quick_posts"
          binding.pry
      @quick_post = @business.quick_posts.find(params[:id])
          binding.pry
    when "events"
          binding.pry
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
          binding.pry
      @offer = @business.offers.find(params[:id])
    when "galleries"
          binding.pry
      @gallery = @business.galleries.find(params[:id])
    when "gallery_images"
          binding.pry
      @gallery = @business.galleries.find(params[:id])
      @gallery_image = GalleryImage.find(params[:image_id])
      binding.pry
    else
      binding.pry
      raise ActiveRecord::RecordNotFound
    end

    @preview = true
    binding.pry
    render "website/#{params[:type]}/show"

  end
end
