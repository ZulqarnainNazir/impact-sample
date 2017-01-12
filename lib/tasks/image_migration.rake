desc 'Move Images to New Lamba-Based Resizing and S3 Directory Structure'
task image_migration: [:environment] do
  Image.class_eval('has_attached_file :attachment, styles: lambda { |attachment| attachment.instance.styles }')

  def process_image(s3_bucket, image, trial_run = true)
    # Skip if it's already in the new format
    if image.attachment_cache_url.present? &&
       (image.attachment_cache_url.include?('_originals') ||
        image.attachment_cache_url.include?('_logos'))
      puts "SKIPPING image #{image.id} - already in new format"
      return
    end

    if image.attachment_cache_url.include?('fbcdn.net')
      unless trial_run
        api_endpoint = ENV['LAMBDA_API_ENDPOINT']
        api_key = ENV['LAMBDA_API_KEY']

        s3_path = URI.parse(image.attachment_cache_url).path

        HTTParty.post(api_endpoint, body: { facebook_image_url: image.attachment_cache_url,
                                            api_key: api_key }.to_json)

        image.update(attachment_cache_url: "//#{ENV['AWS_S3_BUCKET']}.s3.amazonaws.com/_originals/_fb#{s3_path}")
      end

      puts "Success. Image: #{image.id} sent to FB Lambda for processing"
      return
    end

    key = if image.attachment && image.attachment.url.present? && image.attachment.file?
            URI.parse(image.attachment.url).path[1..-1]
          elsif image.attachment_cache_url.present?
            URI.parse(image.attachment_cache_url).path[1..-1]
          end

    s3_object = s3_bucket.objects[key]

    if s3_object.exists?
      logo = image.cached_styles.to_s.include?('logo_')
      base_dir = logo ? '_logos/' : '_originals/'
      new_key = "#{base_dir}#{key}"

      s3_object.copy_to(new_key, acl: :public_read) unless trial_run

      image.update(attachment_cache_url: s3_object.public_url.gsub(key, new_key)) unless trial_run
      puts "Success. Image: #{image.id} update"
    else
      puts "ERROR: COULD NOT PROCESS #{image.id}"
    end
  end

  s3_bucket = AWS::S3.new.buckets[ENV['AWS_S3_BUCKET']]

  Image.find_each do |image|
    process_image(s3_bucket, image, false)
  end
end
