class Businesses::ContentTagsController < Businesses::BaseController
  layout false

  def index
    @content_tags = @business.content_tags.where('name ILIKE ?', "%#{params[:query].to_s.strip}%").limit(20)
    render json: @content_tags.as_json
  end

  def create
    @content_tag = @business.content_tags.new(content_tag_params)

    if @content_tag.save
      render json: @content_tag.to_json
    else
      render text: '', status: 422
    end
  end

  private

  def content_tag_params
    params.require(:content_tag).permit(
      :name,
    )
  end
end
