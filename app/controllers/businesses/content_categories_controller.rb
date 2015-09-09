class Businesses::ContentCategoriesController < Businesses::BaseController
  layout false

  before_action do
    @content_category = @business.content_categories.new
  end

  def create
    @content_category.assign_attributes(content_category_params)

    if @content_category.save
      render json: @content_category.to_json
    else
      render :new, status: 422
    end
  end

  private

  def content_category_params
    params.require(:content_category).permit(
      :name,
    )
  end
end
