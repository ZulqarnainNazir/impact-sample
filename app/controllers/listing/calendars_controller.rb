class Listing::CalendarsController < ApplicationController
  layout "listing"

  include ApplicationHelper
  include SearchHelper
  before_action do
    @business = Business.listing_lookup(params[:lookup])
    @calendar_widgets = @business.calendar_widgets

    default = {:id => @calendar_widgets.first.id}
    if params[:calendar_widget].nil?
      params[:calendar_widget] = default
    end
    @calendar_widget = CalendarWidget.find(params[:calendar_widget][:id])


    @content_feed_widget = ContentFeedWidget.new  # empty "fake" content widget in order to display business content
    @content_feed_widget.business = @business
    @content_feed_widget.max_items = 12
    params[:content_types] = ["QuickPost","Gallery", "BeforeAfter", "Offer", "Job" ,"CustomPost",""]
    @posts = content_feed_widget_base(@content_feed_widget, @content_feed_widget.business, content_types: params[:content_types], content_category_ids: @content_feed_widget.content_category_ids.map(&:to_i), content_tag_ids: @content_feed_widget.content_tag_ids.map(&:to_i), page: params[:page], limit: @content_feed_widget.max_items)


  end

  before_action only: [:index] do
    default = {:id => @calendar_widgets.first.id}
    if params[:calendar_widget].nil?
      params[:calendar_widget] = default
    end
    @calendar_widget = CalendarWidget.find(params[:calendar_widget][:id])
  end

  def index

  end


end
