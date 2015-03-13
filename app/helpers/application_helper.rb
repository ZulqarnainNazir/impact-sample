module ApplicationHelper
  def errors_for(resource, message: nil)
    if resource && resource.errors.full_messages.any?
      render partial: 'errors', locals: { message: message, error_messages: resource.errors.full_messages }
    end
  end

  def s3_bucket
    AWS::S3.new.buckets[ENV['AWS_S3_BUCKET']]
  end

  def s3_cache_key
    "cache/#{SecureRandom.uuid}/${filename}"
  end

  def s3_presigned_post
    s3_bucket.presigned_post(acl: :public_read, key: s3_cache_key, success_action_status: 201).where(:content_type).starts_with('')
  end

  def title(string_or_locals = {})
    if string_or_locals.is_a? String
      content_for :title, string_or_locals
    end
  end

  def website_host(website)
    [website.subdomain, Rails.application.secrets.host].join('.')
  end
end
