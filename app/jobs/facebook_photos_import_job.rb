class FacebookPhotosImportJob < ActiveJob::Base
  queue_as :default

  def perform(business, user)
    oauth = Koala::Facebook::OAuth.new(Rails.application.secrets.facebook_app_id, Rails.application.secrets.facebook_app_secret, nil)
    token = oauth.get_app_access_token
    graph = Koala::Facebook::API.new(token)

    graph.get_connections(business.facebook_id, 'photos').each do |photo|
      Image.create(
        attachment_cache_url: photo['source'],
        attachment_file_name: (File.basename(URI.parse(picture['source']).path) rescue nil),
        alt: photo['name'],
        business: business,
        user: user,
      )
    end
  end
end
