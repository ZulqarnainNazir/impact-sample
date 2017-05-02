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
    business.events.
      where('occurs_on >= ?', Time.zone.now).
      order(occurs_on: :asc).
      page(page).
      per(limit)
  end

  def events_organized_desc(business, page: 1, limit: 4)
    business.events.
      where('occurs_on >= ?', Time.zone.now).
      order(occurs_on: :desc).
      page(page).
      per(limit)
  end

  def posts(business, content_types: [], content_category_ids: [], content_tag_ids: [], page: 1, limit: 4)
    Kaminari.paginate_array(
        ContentBlogSearch.new(
          business, 
          '', 
          content_types: content_types, 
          content_category_ids: content_category_ids, 
          content_tag_ids: content_tag_ids
        ).search
      ).page(page).per(limit)
  end

  def blog_search_base(business, search_string, content_types: [], content_category_ids: [], content_tag_ids: [], page: 1, limit: 4)
    Kaminari.paginate_array(
        ContentBlogSearch.new(
          business, 
          search_string, 
          content_types: content_types,
          content_category_ids: content_category_ids, 
          content_tag_ids: content_tag_ids
        ).search
      ).page(page).per(limit)
  end

  #get_content_types method is a critical method for 
  #getting the right content types to show, as scoped by type. 
  #e.g., if the homepage is scoped to show events and before and after, 
  #this method should be used in the
  #home_pages_controller.

  def render_content_type_partial(object, engage)
    if engage == false
    	if object.class.name == "Post"
    		render 'website/posts/post', post: object
    	elsif object.class.name == "Offer"
    		render 'website/offers/offer', offer: object
    	elsif object.class.name == "BeforeAfter"
    		render 'website/before_afters/before_after', before_after: object
    	elsif object.class.name == "Gallery"
    		render 'website/galleries/gallery', gallery: object
    	elsif object.class.name == "EventDefinition"
    		render 'website/event_definitions/event_definition', event_definition: object
    	elsif object.class.name == "QuickPost"
    		render 'website/quick_posts/quick_post', quick_post: object
    	end
    elsif engage == true
      if object.class.name == "Post"
        render 'listing/listings/post', post: object
      elsif object.class.name == "Offer"
        render 'listing/listings/offer', offer: object
      elsif object.class.name == "BeforeAfter"
        render 'listing/listings/before_after', before_after: object
      elsif object.class.name == "Gallery"
        render 'listing/listings/gallery', gallery: object
      elsif object.class.name == "EventDefinition"
        render 'listing/listings/event_definition', event_definition: object
      elsif object.class.name == "QuickPost"
        render 'listing/listings/quick_post', quick_post: object
      end
    end
  end

  def get_content_types(group_type, page_instance_variable)
    if page_instance_variable.groups.where(type: group_type).first.try(:blocks)
      @content_types_all = page_instance_variable.groups.where(type: group_type).first.blocks.first.content_types
      if @content_types_all.nil? || @content_types_all.empty? # ||....<=checks to see if "", empty string, is in db, signifying "show all content types"
        @content_types_all = "Event Gallery BeforeAfter Offer Post"
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