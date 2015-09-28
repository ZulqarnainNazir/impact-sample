class AuthenticationsController < ApplicationController
  def facebook_page
    begin
      raise ArgumentError unless params[:code].present?
      raise ArgumentError unless params[:business_id].present?
      raise ArgumentError unless params[:facebook_id].present?
      business = Business.find(params[:business_id])
      callback_url = url_for([:authenticate_facebook_page, business_id: params[:business_id], facebook_id: params[:facebook_id], only_path: false])
      oauth = Koala::Facebook::OAuth.new(Rails.application.secrets.facebook_app_id, Rails.application.secrets.facebook_app_secret, callback_url)
      app_token = oauth.get_app_access_token
      user_token = oauth.get_access_token(params[:code])
      user_graph = Koala::Facebook::API.new(user_token)
      page_token = user_graph.get_page_access_token(params[:facebook_id])
      raise ArgumentError unless page_token.present?
      update_resource business, { facebook_id: params[:facebook_id], facebook_token: page_token, automated_export_facebook_reviews: '0' }, location: [:edit, business, :accounts_facebook]
    rescue
      business = Business.find_by_id(params[:business_id])
      if business
        redirect_to [:edit, business, :accounts_facebook], alert: t('.alert')
      else
        redirect_to root_path, alert: t('.alert')
      end
    end
  end
end
