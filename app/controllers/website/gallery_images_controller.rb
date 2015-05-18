class Website::GalleryImagesController < Website::BaseController
  def show
    @gallery = @business.galleries.find(params[:gallery_id])
    @gallery_image = @gallery.gallery_images.find(params[:id])
  end
end
