class Website::ContentCategoriesController < Website::BaseController
  def show
    @content_category = @business.content_categories.find(params[:id])
    @posts = get_content(business: @business, content_category_ids: [@content_category.id], order: 'desc', page: params[:page], per_page: '12')

  end
end
