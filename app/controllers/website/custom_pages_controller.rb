class Website::CustomPagesController < Website::BaseController
  # TODO - Ideally we get rid of this but how do we do so while still allowing mutlple embeds on the same page?
  helper_method :get_events

  before_action do
    @page = @website.webpages.custom.find_by_pathname!(params[:id])

    # TODO - I think this should be in widget controller not on cutom pages...
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

    # @content_types_all = "QuickPost Offer Job Gallery BeforeAfter Post".split


    #TODO - THis cant be in this controller...it needs to be in feeds controller or somewhere so we can have mutliplte embeds on a page...
    # block = @page.groups.where(type: 'BlogFeedGroup').last.blocks.last
    #
    # @posts = get_content(business: block.business, embed: block, query: params[:blog_search], content_types: @content_types, content_category_ids: block.content_category_ids ? block.content_category_ids.split : '', content_tag_ids: block.content_tag_ids ? block.content_tag_ids.split : '', page: params[:page], per_page: block.items_limit)

  end

  def show

    # if @page.groups.where(type: 'CalendarGroup').first.present?
    #   @calendar_widget = CalendarWidget.find_by(id: @page.groups.where(type: 'CalendarGroup').first.blocks.first.widget_id)

  end

end
