module DirectoryContentSearchConcern
  extend ActiveSupport::Concern

  def search_directory_content(business, query = '', content_category_ids = [], content_tag_ids = [])
    # Finds content for a given business for display in widget, web builder or listings

    # @widget = widget
    # @business = business
    # @business_ids = @widget.get_business_ids #business_ids should be an array; returns array of Business ids, or empty array
    # if @widget.show_our_content == true
    @business_id = business.id #includes parent business' content
    # end
    @query = query.to_s.strip
    # @content_types = content_types
    @content_category_ids = content_category_ids
    @content_tag_ids = content_tag_ids
    # @include_past = include_past

    offers = OfferSearchConcern.new
    offers = offers.search_event([], @business_id, @query = '', @content_category_ids, @content_tag_ids)

    galleries = GallerySearchConcern.new
    galleries = galleries.search_event([], @business_id, @query = '', @content_category_ids, @content_tag_ids)

    posts = PostSearchConcern.new
    posts = posts.search_event([], @business_id, @query = '', @content_category_ids, @content_tag_ids)

    quick_posts = QuickPostSearchConcern.new
    quick_posts = quick_posts.search_event([], @business_id, @query = '', @content_category_ids, @content_tag_ids)

    before_afters = BeforeAfterSearchConcern.new
    before_afters = before_afters.search_event([], @business_id, @query = '', @content_category_ids, @content_tag_ids)

    jobs = JobSearchConcern.new
    jobs = jobs.search_event([], @business_id, @query = '', @content_category_ids, @content_tag_ids)



    (offers + galleries + posts + quick_posts + before_afters).sort_by {|obj| obj.published_at}.reverse!

  end
end
