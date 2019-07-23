class Website::ContentTagsController < Website::BaseController
  def show
    @content_tag = @business.content_tags.find(params[:id])
    @posts = get_content(business: @business, content_tag_ids: [@content_tag.id], order: 'desc', page: params[:page], per_page: '12')
  end
end
