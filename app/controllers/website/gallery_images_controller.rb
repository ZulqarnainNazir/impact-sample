class Website::GalleryImagesController < Website::BaseController
  def show
    @gallery = @business.galleries.find(params[:gallery_id])
    @gallery_image = @gallery.gallery_images.find(params[:id])
    image_path = website_generic_post_path(@gallery.to_generic_param) + "/#{@gallery_image.id}/#{@gallery_image.gallery_image.title.parameterize || 'no-title'}"
    redirect_to image_path, status: 301
  end
end
