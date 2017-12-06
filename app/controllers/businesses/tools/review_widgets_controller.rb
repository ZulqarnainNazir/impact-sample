class Businesses::Tools::ReviewWidgetsController < Businesses::BaseController
  before_action -> { confirm_module_activated(3) }
  before_action only: new_actions do
    @review_widget = @business.review_widgets.new
  end

  before_action only: member_actions do
    @review_widget = @business.review_widgets.find(params[:id])
  end

  def index
    scope = @business.review_widgets
    query = params[:query].to_s.strip

    if query.present?
      scope = scope.where('name ILIKE ?', "%#{query}%")
    end

    @review_widgets = scope.page(params[:page]).per(20)
  end

  def create
    create_resource @review_widget, review_widget_params, location: [:edit, @business, :tools, @review_widget]
  end

  def update
    review_widget = @business.review_widgets.find(params[:id])
    if review_widget.update_attributes(review_widget_params)
      redirect_to [@business, :tools_review_widgets]
    else
      render 'edit'
    end
  end

  def destroy
    Widget.destroy(@review_widget.id)
    redirect_to [@business, :tools_review_widgets]
  end

  private

  def review_widget_params
    params.require(:review_widget).permit(:name, :description, :label, :layout)
  end

end
