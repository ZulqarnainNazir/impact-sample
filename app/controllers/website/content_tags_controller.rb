class Website::ContentTagsController < Website::BaseController
  def show
    @content_tag = @business.content_tags.find(params[:id])
  end
end
