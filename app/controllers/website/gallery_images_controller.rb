class Website::GalleryImagesController < Website::BaseController
  def show
    @gallery = @business.galleries.find(params[:gallery_id])
    @gallery_image = @gallery.gallery_images.find(params[:id])
    redirect_to website_generic_post_path(@gallery_image.to_generic_param), status: 301
  end
end
