class Website::BlogPagesController < Website::BaseController
  before_action do
    @page = @website.blog_page

    if !@page
      raise ActiveRecord::RecordNotFound
    elsif !@page.active? && !@business.owners.include?(current_user) && false
      raise ActiveRecord::RecordNotFound
    else
      @feed_items = ContentSearch.new(@business, params[:query]).search.page(params[:page]).per(@page.per_page).records
    end
  end
end
