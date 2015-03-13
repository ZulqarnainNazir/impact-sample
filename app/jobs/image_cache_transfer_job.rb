class ImageCacheTransferJob < ActiveJob::Base
  queue_as :default

  def perform(image)
    if image.attachment_cache_url?
      image.update attachment: URI.parse("http:#{image.attachment_cache_url.gsub(/\s/, '+')}"), attachment_cache_url: nil
    end
  end
end
