class Businesses::ContentTagsController < Businesses::BaseController
  layout false

  def index
    @content_tags = @business.content_tags.where('name ILIKE ?', "%#{params[:query].to_s.strip.downcase}%").uniq.limit(5)
    render json: @content_tags.as_json
  end

  def create
    if existing_tag = @business.content_tags.where('name ILIKE ?', "%#{content_tag_params[:name].to_s.strip.downcase}%").first
      render json: existing_tag.to_json
      return
    end

    @content_tag = @business.content_tags.new(content_tag_params)
    @content_tag.name.downcase!
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
