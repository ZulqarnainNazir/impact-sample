class Businesses::ContentTagsController < Businesses::BaseController
  layout false

  def index
    @content_tags = @business.content_tags.where('name ILIKE ?', "#{params[:query].to_s.strip}").limit(20)
    render json: @content_tags.as_json
  end
end
