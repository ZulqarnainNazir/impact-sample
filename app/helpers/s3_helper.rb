module S3Helper
  def s3_bucket
    AWS::S3.new.buckets[ENV['AWS_S3_BUCKET']]
  end

  def s3_cache_key
    "cache/#{SecureRandom.uuid}/${filename}"
  end

  def s3_presigned_post
    s3_bucket.presigned_post(acl: :public_read, key: s3_cache_key, success_action_status: 201).where(:content_type).starts_with('')
  end

  def s3_presigned_post_hash
    post = s3_presigned_post
    {
      fields: post.fields,
      host: post.url.host,
      url: post.url.to_s,
    }
  end
end
