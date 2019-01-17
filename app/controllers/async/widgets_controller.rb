class Async::WidgetsController < ApplicationController

  def calendar
    @event = Event.find(params.dig(:event))
    @business = @event.business
    @website = @business.website
    render layout: false
  end

  def quick_post
    @quick_post = QuickPost.find(params.dig(:quick_post))
    render layout: false
  end
end
