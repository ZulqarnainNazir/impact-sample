class ImageCacheTransferJob < ActiveJob::Base
  queue_as :image

  def perform(image)
    if image.attachment_cache_url?
      if image.attachment_cache_url.match(/\Ahttp/)
        image.update attachment: URI.parse(image.attachment_cache_url.gsub(/\s/, '+')), attachment_cache_url: nil
      else
        image.update attachment: URI.parse("http:#{image.attachment_cache_url.gsub(/\s/, '+')}"), attachment_cache_url: nil
      end
    end
  end
end
