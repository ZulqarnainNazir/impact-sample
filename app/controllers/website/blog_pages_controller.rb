class Website::BlogPagesController < Website::BaseController
  before_action do
    @page = @website.blog_page or raise ActiveRecord::RecordNotFound
    # get_content_types("BlogFeedGroup", @page)

    if params[:content_types]
        @content_types = params[:content_types]
    # elsif @page.groups.where(type: 'BlogFeedGroup').first.try(:blocks)
    #   # TODO - Below returns wrong types so should update source to pass correct types (remove event, change custompost to post) so don't need the delete and add functions
    #   @content_types = @page.groups.where(type: 'BlogFeedGroup').first.blocks.first.content_types.split
    #   @content_types.delete('Event')
    #   @content_types.delete('CustomPost')
    #   @content_types << 'Post'
    else
      @content_types = "QuickPost Offer Job Gallery BeforeAfter Post".split
    end

    @content_types_all = "QuickPost Offer Job Gallery BeforeAfter Post".split
  end
end
