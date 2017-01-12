class Widgets::ReviewWidgetsController < Widgets::BaseController
  def index
    @widget = ReviewWidget.where(:uuid => params[:uuid]).first
    @reviews = @widget.business.reviews.published.order(reviewed_at: :desc).page(params[:page]).per(20)
    @business = @widget.business
    if !params[:widget_layout].blank?
      @widget.layout = params[:widget_layout]
    end
  end
end
