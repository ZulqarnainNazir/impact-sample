class Website::BlogPagesController < Website::BaseController
  before_action do
    @page = @website.blog_page

    if !@page
      raise ActiveRecord::RecordNotFound
    elsif !@page.active? && !@business.owners.include?(current_user) && false
      raise ActiveRecord::RecordNotFound
    else
      feed_record_arrays = %i[before_afters galleries offers posts].map do |association|
        @business.send(association).order(created_at: :desc).limit(@page.per_page)
      end.inject(&:+).sort_by(&:created_at).reverse

      @feed_items = Kaminari.paginate_array(feed_record_arrays).page(1).per(@page.per_page)
    end
  end
end
