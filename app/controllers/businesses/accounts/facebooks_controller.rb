class Businesses::Accounts::FacebooksController < Businesses::BaseController
  before_action only: %i[edit update] do
    if @business.facebook_id? && @business.facebook_token?
      oauth = Koala::Facebook::OAuth.new(Rails.application.secrets.facebook_app_id, Rails.application.secrets.facebook_app_secret, nil)
      graph = Koala::Facebook::API.new(@business.facebook_token)
      @linked_facebook_page = graph.get_object(@business.facebook_id).with_indifferent_access
    end
  end

  def update
    if @linked_facebook_page
      update_resource @business, facebook_automation_params, location: [:edit, @business, :accounts_facebook] do |success|
        if success
          if @business.automated_export_facebook_reviews == '1'
            FacebookReviewsExportJob.perform_later(@business)
          end
        end
      end
    else
      begin
        @business.facebook_id = params[:business].try(:[], :facebook_id).to_s.split('/').last.split('?').first
        callback_url = url_for([:authenticate_facebook_page, business_id: @business.id, facebook_id: @business.facebook_id, only_path: false])
        oauth = Koala::Facebook::OAuth.new(Rails.application.secrets.facebook_app_id, Rails.application.secrets.facebook_app_secret, callback_url)
        redirect_to oauth.url_for_oauth_code(permissions: 'manage_pages publish_pages')
      rescue
        flash.now.alert = t('.alert')
        render :edit
      end
    end
  end

  def destroy
    update_resource @business, { facebook_id: nil, facebook_token: nil, automated_export_facebook_reviews: '0' }, location: [:edit, @business, :accounts_facebook]
  end

  private

  def facebook_automation_params
    params.require(:business).permit(
      :automated_export_facebook_reviews,
    )
  end
end
