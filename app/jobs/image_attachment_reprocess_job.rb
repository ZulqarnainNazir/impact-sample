class ImageAttachmentReprocessJob < ActiveJob::Base
  queue_as :default

  def perform(image)
    if image && image.attachment
      image.attachment.reprocess!
    end
  end
end
