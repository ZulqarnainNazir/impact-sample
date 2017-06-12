class Website::GalleryImagesController < Website::BaseController
  def show
  	@gallery = @business.galleries.find(params[:gallery_id])
    @gallery_image = @gallery.gallery_images.find(params[:id])
    generic_params = @gallery.to_generic_param
    if params[:uuid] =~ /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/
      generic_params[:uuid] = params[:uuid]
    end
	image_path = website_generic_post_path(generic_params) + "/#{@gallery_image.id}/#{title_for_url}"
    redirect_to image_path, status: 301
  end

  private

  def title_for_url
    if @gallery_image.gallery_image.attachment_file_name.present?
      @gallery_image.gallery_image.attachment_file_name.parameterize
    else
      'no-title'
    end
  end
end
