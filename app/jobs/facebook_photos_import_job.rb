class FacebookPhotosImportJob < ApplicationJob
  def perform(business, user)
    oauth = Koala::Facebook::OAuth.new(Rails.application.secrets.facebook_app_id, Rails.application.secrets.facebook_app_secret, nil)
    token = oauth.get_app_access_token
    graph = Koala::Facebook::API.new(token)
    album_limit = 10
    photo_limit = 50
    api_endpoint = Rails.application.secrets.lambda_api_endpoint
    api_key = Rails.application.secrets.lambda_api_key

    graph.get_connections(business.facebook_id, 'albums')[0..album_limit].each do |album|
      graph.get_connections(album['id'], 'photos')[0..photo_limit].each do |photo|
        if photo['images'].any?
          photo = photo['images'].max_by { |img| img['width'] * img['height'] }
        end

        s3_path = URI.parse(photo['source']).path

        HTTParty.post(api_endpoint, body: { facebook_image_url: photo['source'],
                                            api_key: api_key }.to_json)

        Image.create(
          attachment_cache_url: "//#{Rails.application.secrets.aws_s3_bucket}.s3.amazonaws.com/_originals/_fb#{s3_path}",
          attachment_file_name: (File.basename(URI.parse(photo['source']).path) rescue nil),
          alt: photo['name'],
          business: business,
          user: user,
        )
      end
    end
  end
end
