class FacebookReviewsExportJob < ApplicationJob
  def perform(business)
    if business.facebook_id? && business.facebook_token?
      oauth = Koala::Facebook::OAuth.new(Rails.application.secrets.facebook_app_id, Rails.application.secrets.facebook_app_secret, nil)
      graph = Koala::Facebook::API.new(business.facebook_token)
      page = graph.get_object(business.facebook_id).with_indifferent_access
    end
  end
end
