class Website::HomePagesController < Website::BaseController
  before_action do
    @page = @website.home_page

    if !@page
      raise ActiveRecord::RecordNotFound
    elsif !@page.active? && !@business.owners.include?(current_user) && false
      raise ActiveRecord::RecordNotFound
    end

    if @website.blog_page && @page.feed_block
      feed_record_arrays = %i[before_afters galleries offers posts].map do |association|
        @business.send(association).order(created_at: :desc).limit(@page.feed_block.items_limit)
      end.inject(&:+).sort_by(&:created_at).reverse

      @feed_items = Kaminari.paginate_array(feed_record_arrays).page(1).per(@page.feed_block.items_limit)
    end
  end
end
