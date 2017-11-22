class S3Service
  def self.bucket
    @bucket ||= AWS::S3.new.buckets[Rails.application.secrets.aws_s3_bucket]
  end

  def self.download(key, destination)
    File.open(destination, 'w') do |file|
      body = bucket.objects[formatted_key(key)].read
      file.puts body.force_encoding('UTF-8')
    end
  end

  def self.upload(filename)
    bucket.objects.create formatted_key(filename), File.new(filename)
  end

  def self.formatted_key(key)
    namespace = "#{Rails.env.downcase}_tmp"
    basekey = File.basename(key)

    formatted = basekey.to_s.match(namespace) ? basekey : "#{namespace}/#{basekey}"
    formatted.gsub('//', '/')
  end
end
