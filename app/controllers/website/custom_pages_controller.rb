class Website::CustomPagesController < Website::BaseController

  before_action do
    @page = @website.webpages.custom.find_by_pathname!(params[:id])

  end

  def show

    #TODO - How to do this and still allow multiple emebeds on page?

    # Get Posts - Curerntly in view partial
    # if params[:content_types]
    #     @content_types = params[:content_types]
    # elsif @page.groups.where(type: 'BlogFeedGroup').first.try(:blocks)
    #   # TODO - Below returns wrong types so should update source to pass correct types (remove event, change custompost to post) so don't need the delete and add functions
    #   @content_types = @page.groups.where(type: 'BlogFeedGroup').first.blocks.first.content_types.split
    #   @content_types.delete('Event')
    #   @content_types.delete('CustomPost')
    #   @content_types << 'Post'
    # else
    #   @content_types = "QuickPost Offer Job Gallery BeforeAfter Post".split
    # end

    # block = @page.groups.where(type: 'BlogFeedGroup').last.blocks.last
    # @posts = get_content(business: block.business, embed: block, query: params[:blog_search], content_types: @content_types, content_category_ids: block.content_category_ids ? block.content_category_ids.split : '', content_tag_ids: block.content_tag_ids ? block.content_tag_ids.split : '', page: params[:page], per_page: block.items_limit)

    # Get Events - Currently in view partial
    # if @page.groups.where(type: 'CalendarGroup').first.present?
    #   @calendar_widget = CalendarWidget.find_by(id: @page.groups.where(type: 'CalendarGroup').first.blocks.first.widget_id)

  end

end
