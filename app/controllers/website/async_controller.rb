class Website::AsyncController < Website::BaseController
  def quick_post
    @post = QuickPost.find(params[:post_id])
    render partial: "website/#{@post.to_partial_path}" + "_modal", object: @post, as: @post.class.name.underscore
  end
  def post
    @post = Post.find(params[:post_id])
    render partial: "website/#{@post.to_partial_path}" + "_modal", object: @post, as: @post.class.name.underscore
  end

  def calendar_event
    @event = Event.find(params[:event_id])
    @main_business = Business.find(params[:main_biz])
    previous_index = Event.find(params[:previous_index]) #YTHO

    render partial: "widgets/calendar_widgets/content/event_#{params[:container_view]}_item", locals: { event: @event, business: @event.business, website: @event.business.website, main_biz: @main_business, prev: (params[:index].to_i <= 0 ? nil : previous_index) }
  end
end
