module EmailHelper
  def email_image_tag(image, **options)
    if Rails.env.development?
      image_tag image, **options
    else
      attachments.inline[image] = File.read(Rails.root.join("app/assets/images/#{image}"))
      image_tag attachments[image].url, **options
    end
  end

  def email_image_url(image)
    if Rails.env.development?
      image_url(image)
    else
      attachments.inline[image] = File.read(Rails.root.join("app/assets/images/#{image}"))
      attachments[image].url
    end
  end
end
