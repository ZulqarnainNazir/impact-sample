class LocableBusinessSocialMediaProperty < ActiveRecord::Base
  establish_connection ENV['CONNECT_DB_URL']
  self.table_name = 'business_social_media_properties'
end
