class Businesses::ContentTagsController < Businesses::BaseController
  layout false

  def index
    @content_tags = @business.content_tags.where('lower(name) ILIKE ?', "%#{params[:query].to_s.strip.downcase}%").limit(5)
    render json: @content_tags.as_json
  end

  def create
    if existing_tag = @business.content_tags.where(name: content_tag_params[:name]).first
      render json: existing_tag.to_json
      return
    end

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
