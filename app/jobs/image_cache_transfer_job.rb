class ImageCacheTransferJob < ApplicationJob
  queue_as :image

  def perform(image)
    if image.attachment_cache_url?
      url = image.attachment_cache_url.gsub(/\s/, '+')
      url = "http:#{url}" if url.match(/\A\/\//)
      image.update!(attachment: URI.parse(url), attachment_cache_url: nil)
    end
  end
end
