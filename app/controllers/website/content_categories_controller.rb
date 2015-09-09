class Website::ContentCategoriesController < Website::BaseController
  def show
    @content_category = @business.content_categories.find(params[:id])
  end
end
