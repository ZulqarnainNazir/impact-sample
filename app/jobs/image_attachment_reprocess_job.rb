class ImageAttachmentReprocessJob < ApplicationJob
  queue_as :image

  def perform(image)
    if image.attachment
      image.attachment.reprocess!
    end
  end
end
