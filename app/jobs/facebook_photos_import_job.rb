class FacebookPhotosImportJob < ApplicationJob
  def perform(business, user)
    oauth = Koala::Facebook::OAuth.new(Rails.application.secrets.facebook_app_id, Rails.application.secrets.facebook_app_secret, nil)
    token = oauth.get_app_access_token
    graph = Koala::Facebook::API.new(token)
    album_limit = 10
    photo_limit = 20

    graph.get_connections(business.facebook_id, 'albums')[0..album_limit].each do |album|
      graph.get_connections(album['id'], 'photos')[0..photo_limit].each do |photo|
        Image.create(
          attachment_cache_url: photo['source'],
          attachment_file_name: (File.basename(URI.parse(photo['source']).path) rescue nil),
          alt: photo['name'],
          business: business,
          user: user,
        )
      end
    end
  end
end
