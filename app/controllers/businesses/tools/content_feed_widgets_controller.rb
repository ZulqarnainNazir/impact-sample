class Businesses::Tools::ContentFeedWidgetsController < Businesses::BaseController
  #before_action -> { confirm_module_activated(1) }
  before_action only: new_actions do
    @content_feed_widget = @business.content_feed_widgets.new
  end

  before_action only: member_actions do
    @content_feed_widget = @business.content_feed_widgets.find(params[:id])
  end

  def index
    scope = @business.content_feed_widgets
    query = params[:query].to_s.strip

    if query.present?
      scope = scope.where('name ILIKE ?', "%#{query}%")
    end

    @content_feed_widgets = scope.page(params[:page]).per(20)
  end

  def create
    create_resource @content_feed_widget, content_feed_widget_params, location: [:edit, @business, :tools, @content_feed_widget]
  end

  def update
    content_feed_widget = @business.content_feed_widgets.find(params[:id])
    if content_feed_widget.update_attributes(content_feed_widget_params)
      redirect_to [:edit, @business, :tools, @content_feed_widget], :flash => { :notice => "Widget Saved Successfully" }
    else
      redirect_to [:edit, @business, :tools, @content_feed_widget], :flash => { :warning => "Widget Saved Failed" }
    end
  end

  def destroy
    ContentFeedWidget.destroy(@content_feed_widget.id)
    redirect_to [@business, :tools_content_feed_widgets]
  end

  private

  def content_feed_widget_params
    params.require(:content_feed_widget).permit(:name, :public_label, :max_items, :link_version, :link_id,
                                          :link_label, :link_target_blank, :link_nofollow, :enable_search, :show_our_content, :company_list_ids => [],
                                          :content_types => [], :content_category_ids => [], :content_tag_ids => [])
  end

end
