class Website::BlogPagesController < Website::BaseController
  before_action do
    @page = @website.blog_page or raise ActiveRecord::RecordNotFound

    if params[:content_types]
      @content_types = params[:content_types]
    else
      @content_types = ALL_CONTENT_TYPES
    end

    @content_types_all = ALL_CONTENT_TYPES

    @posts = get_content(business: @page.website.business, embed: @page.groups.container.first.blocks.first, query: params[:blog_search], content_types: @content_types, content_category_ids: @page.groups.container.first.blocks.first.content_category_ids ? @page.groups.container.first.blocks.first.content_category_ids.split : [], content_tag_ids: @page.groups.container.first.blocks.first.content_tag_ids ? @page.groups.container.first.blocks.first.content_tag_ids.split : [], page: params[:page], per_page: @page.groups.container.first.blocks.first.items_limit)
  end
end
