class Website::ReviewsController < Website::BaseController
  def index
    @reviews = @business.reviews.order(reviewed_at: :desc).page(params[:page]).per(20)
  end

  def show
    @review = @business.reviews.find(params[:id])
  end
end
