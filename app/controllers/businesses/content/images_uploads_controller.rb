class Businesses::Content::ImagesUploadsController < Businesses::Content::BaseController
  def create
    @image = @business.images.new(user: current_user)
    @image.assign_attributes(image_params)

    if @image.save
      render text: 'Ok'
    else
      render text: 'Uh-oh', status: 422
    end
  end

  private

  def image_params
    params.require(:image).permit(
      :attachment_cache_url,
      :attachment_content_type,
      :attachment_file_name,
      :attachment_file_size,
    )
  end
end
