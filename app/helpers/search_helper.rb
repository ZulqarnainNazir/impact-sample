module SearchHelper

  def order_the_events(array)
    #purpose of method is to take an array containing various content types
    #pluck the events, and rearrange them from earliest to latest
    #while maintaining the original integrity of order
    events = []
    position = []
    array.each_with_index do |n, index|
      if n.class.name == "Event"
         events << n
         position << index
      end
    end

    if events.count >= 2
      events = events.reverse
      position = position.reverse

      events.each do |n|
        place = position.pop
        array.insert(place, n)
        array.delete_at(place + 1)
      end
    end

    return array

  end

  def events(business, page: 1, limit: 4)
    business.events.joins(:event_definition).where(:event_definitions => {published_status: true}).
      where('occurs_on >= ?', Time.zone.now).
      order(occurs_on: :asc).
      page(page).
      per(limit)
  end

  ###.joins(:event_definition).where(:event_definitions => {published_status: true})

  def events_organized_desc_listings(business, page: 1, limit: 4)
    Kaminari.paginate_array(business.events.joins(:event_definition).where(:event_definitions => {published_status: true}).
      where('occurs_on >= ?', Time.zone.now).
      order(occurs_on: :desc)).
      page(page).
      per(limit)
  end

  def events_organized_desc(blog_feed_block, business, content_category_ids: [], content_tag_ids: [], include_past: false, page: 1, limit: 4)

    #this method is used to display events on a consumer-facing feed
    #on the client's website.
    #first, it pulls all events for the given business.
    #then, if the user has designated that only events with a certain tag and/or category
    #should appear, it plucks those and gives them to Kaminari to paginate.
    #otherwise, it shows all events.
    #keep in mind that "all events" means those that will occur in the future
    #...unless include_past is true

    @blog_feed_block = blog_feed_block
    @business = business
    @business_ids = []
    if @blog_feed_block != nil
      @business_ids = @blog_feed_block.get_business_ids #returns array of Business ids, or empty array
      unless @blog_feed_block.show_our_content == false
        @business_ids << @business.id #includes parent business' content
      end
    else
      @business_ids << @business.id
    end

    @events = []

    if include_past
      found_events = Event.includes(:business, event_definition: [:main_image, :event_image_placement, :location, :event_image])
                          .where({business_id: @business_ids})
                          .where(event_definitions: { published_status: true })
    else
      found_events = Event.includes(:business, event_definition: [:main_image, :event_image_placement, :location, :event_image])
                          .where(business_id: @business_ids)
                          .where('occurs_on >= ?', Time.zone.now)
                          .where(event_definitions: { published_status: true })
    end

    found_events.
    order(occurs_on: :desc).each do |x|
        tag_ids = x.content_tag_ids
        category_ids = x.content_category_ids

        if !content_category_ids.empty? || !content_tag_ids.empty?

          tag_ids.each do |n|
            if content_tag_ids.include?(n)
              @events << x
            end
          end


          if !@events.include?(x)
            category_ids.each do |n|
              if content_category_ids.include?(n)
                @events << x
              end
            end
          end

        else
          @events << x
        end

      end

      return Kaminari.paginate_array(@events.reverse).page(page).per(limit)
  end

  def posts(blog_feed_block, business, content_types: [], content_category_ids: [], content_tag_ids: [], page: 1, limit: 4)
    #this method is being used not only for /blog pages, but also for directory modals as of 2.21.18 - Taylor Barnette
    Kaminari.paginate_array(
        ContentBlogSearch.new(
          blog_feed_block,
          business,
          '',
          content_types: content_types,
          content_category_ids: content_category_ids,
          content_tag_ids: content_tag_ids
        ).search
      ).page(page).per(limit)
  end

  def blog_search_base(blog_feed_block, business, search_string, content_types: [], content_category_ids: [], content_tag_ids: [], page: 1, limit: 4)
    Kaminari.paginate_array(
        ContentBlogSearch.new(
          blog_feed_block,
          business,
          search_string,
          content_types: content_types,
          content_category_ids: content_category_ids,
          content_tag_ids: content_tag_ids
        ).search
      ).page(page).per(limit)
  end

  #CONTENT FEED WIDGET HELPERS FOR ELASTICSEARCH QUERIES
  def content_feed_widget_base_search(widget, business, search_string, content_types: [], content_category_ids: [], content_tag_ids: [], include_past: false, page: 1, limit: 4)
    #for search queries
    Kaminari.paginate_array(
        ContentFeedWidgetSearch.new(
          widget,
          business,
          search_string,
          content_types: content_types,
          content_category_ids: content_category_ids,
          content_tag_ids: content_tag_ids,
          include_past: include_past
        ).search
      ).page(page).per(limit)
  end

  def content_feed_widget_base(widget, business, content_types: [], content_category_ids: [], content_tag_ids: [], page: 1, limit: 4)
    #excluding search queries
    Kaminari.paginate_array(
        ContentFeedWidgetSearch.new(
          widget,
          business,
          '',
          content_types: content_types,
          content_category_ids: content_category_ids,
          content_tag_ids: content_tag_ids
        ).search
      ).page(page).per(limit)
  end

  def calendar_widget_search(widget, business, search_string, start_date, end_date, filter_kinds: [], page: 1, limit: 4)

    # Find this first, because if we are looking for one date, we may need old events
    date_to_filter = Date.parse start_date rescue nil
    end_date_to_filter = Date.parse end_date rescue nil

    if search_string.present?

      event_definitions = ContentFeedWidgetSearch.new(
          widget,
          business,
          search_string,
          content_types: ['Event'],
          include_past: date_to_filter.present?
        ).search

      if date_to_filter.present?
        events = Event.includes(:business, :event_definition).where(
          event_definition_id: event_definitions).order(:occurs_on)
      else
        events = Event.includes(:business, :event_definition).where(
          event_definition_id: event_definitions
        ).where("occurs_on >= ?", Time.zone.now).order(:occurs_on)
      end

    else
      events = events_organized_desc(
        widget,
        business,
        include_past: date_to_filter.present?,
        page: 1,
        limit: 800)
    end

    if filter_kinds.present?
      events = events.select { |e|
        filter_kinds.include?(e.event_definition.kind)
      }
    end

    if date_to_filter.present?
      events = events.select { |e|
        (e.occurs_on >= date_to_filter) &&
        (end_date_to_filter.blank? || e.occurs_on <= end_date_to_filter)
      }
    end

    sorted_events = events.sort { |a,b|
      if a.occurs_on == b.occurs_on
        a.event_definition.start_time - b.event_definition.start_time
      else
        a.occurs_on - b.occurs_on
      end
    }

    Kaminari.paginate_array(sorted_events).page(page).per(limit)

  end

  #get_content_types method is a critical method for
  #getting the right content types to show, as scoped by type.
  #e.g., if the homepage is scoped to show events and before and after,
  #this method should be used in the
  #home_pages_controller.

  def render_content_type_partial(object, engage)
    if engage == false
      if object.class.name == "Job"
        render 'website/jobs/job', job: object
      elsif object.class.name == "Post"
        render 'website/posts/post', post: object
      elsif object.class.name == "Offer"
        render 'website/offers/offer', offer: object
      elsif object.class.name == "BeforeAfter"
        render 'website/before_afters/before_after', before_after: object
      elsif object.class.name == "Gallery"
        render 'website/galleries/gallery', gallery: object
      elsif object.class.name == "Event"
        render 'website/events/event', event: object
      elsif object.class.name == "EventDefinition"
        render 'website/event_definitions/event_definition', event_definition: object
      elsif object.class.name == "QuickPost"
        render 'website/quick_posts/quick_post', quick_post: object
      end
    elsif engage == true
      # if object.class.name == "Job"
      #   render 'listing/listings/job', job: object
      if object.class.name == "Post"
        render 'listing/listings/post', post: object
      elsif object.class.name == "Offer"
        render 'listing/listings/offer', offer: object
      elsif object.class.name == "BeforeAfter"
        render 'listing/listings/before_after', before_after: object
      elsif object.class.name == "Gallery"
        render 'listing/listings/gallery', gallery: object
      elsif object.class.name == "Event"
        render 'listing/listings/event', event: object
      elsif object.class.name == "EventDefinition"
        render 'listing/listings/event_definition', event_definition: object
      elsif object.class.name == "QuickPost"
        render 'listing/listings/quick_post', quick_post: object
      end
    end
  end

  def get_content_types(group_type, page_instance_variable)
    if defined?(page_instance_variable.content_types) || page_instance_variable.groups.where(type: group_type).first.try(:blocks)
      if defined?(page_instance_variable.content_types)
        @content_types_all = page_instance_variable.content_types.join(" ")
      else
        @content_types_all = page_instance_variable.groups.where(type: group_type).first.blocks.first.content_types
      end
      if @content_types_all.nil? || @content_types_all.empty? # ||....<=checks to see if "", empty string, is in db, signifying "show all content types"
        @content_types_all = "Event Gallery BeforeAfter Offer Post Job"
      end
      if @content_types_all.present?
        @content_types_all = @content_types_all.split
      end
    end
    if !params[:content_types].present? && !@content_types_all.nil?
      params[:content_types] = @content_types_all
    elsif params[:content_types].present?
      @content_types = params[:content_types]
    end
    if @content_types_all.present?
      prune_content_types_all(@content_types_all)
    end
  end

  def prune_content_types_all(content_types_all)

    if @business.quick_posts.empty?
      content_types_all.delete("QuickPost")
    end
    if @business.events.empty?
      content_types_all.delete("Event")
    end
    if @business.galleries.empty?
      content_types_all.delete("Gallery")
    end
    if @business.before_afters.empty?
      content_types_all.delete("BeforeAfter")
    end
    if @business.offers.empty?
      content_types_all.delete("Offer")
    end
    if @business.posts.empty?
      content_types_all.delete("CustomPost")
    end
    if @business.jobs.empty?
      content_types_all.delete("Job")
    end

    #ElasticSearch will search for 'CustomPost' and 'QuickPost' via just 'Post'
    if @content_types_all.include?('CustomPost') || @content_types_all.include?('QuickPost')
      @content_types_all.delete('CustomPost')
      @content_types_all.delete('QuickPost')
      @content_types_all << 'Post'
    end

  end

  # def get_content_types_test(group_type, page_instance_variable)
  #   if page_instance_variable.groups.where(type: group_type).first.try(:blocks)
  #     @content_types_all ||= page_instance_variable.groups.where(type: group_type).first.blocks.first.content_types
  #   end
  #   if @content_types_all.present? && @content_types_all.nil? || @content_types_all.present? && @content_types_all == ""
  #     @content_types_all = "QuickPost Event Gallery BeforeAfter Offer CustomPost"
  #   end
  #   if @content_types_all.present? && !@content_types_all.nil?
  #     @content_types_all = @content_types_all.split
  #   end
  #   if !params[:content_types].present? && !@content_types_all.nil?
  #     params[:content_types] = @content_types_all
  #   elsif params[:content_types].present?
  #     @content_types = params[:content_types]
  #   end
  # end

end
