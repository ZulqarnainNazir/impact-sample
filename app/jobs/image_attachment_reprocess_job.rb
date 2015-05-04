class ImageAttachmentReprocessJob < ActiveJob::Base
  queue_as :image

  def perform(image)
    if image && image.attachment
      image.attachment.reprocess!
    end
  end
end
