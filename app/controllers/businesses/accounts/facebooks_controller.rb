class Businesses::Accounts::FacebooksController < Businesses::BaseController
  before_action only: %i[edit update] do
    if @business.facebook_id? && @business.facebook_token?
      oauth = Koala::Facebook::OAuth.try(:new, Rails.application.secrets.facebook_app_id, Rails.application.secrets.facebook_app_secret, nil)

      begin 
        graph = Koala::Facebook::API.try(:new, @business.facebook_token)
        @linked_facebook_page = graph.try(:get_object, @business.facebook_id).try(:with_indifferent_access)
      rescue
        # handle users that have logged out/changed pw
        graph = Koala::Facebook::API.try(:new, oauth.get_app_access_token)
        @linked_facebook_page = graph.try(:get_object, @business.facebook_id).try(:with_indifferent_access)
      end
    end
  end

  def edit
    if @business.facebook_id? && @business.facebook_token? && @linked_facebook_page && !@linked_facebook_page.nil?
      @linked_facebook_page
      redirect_to business_accounts_root_path(@business)
    else 
      @linked_facebook_page = nil
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
        @business.facebook_id = facebook_id
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
    @business = Business.find(params[:business_id])
    @business.update_columns(facebook_id: nil, facebook_token: nil)
    @business.automated_export_facebook_reviews = '0'
    respond_to do |format|
      format.js { redirect_to edit_business_accounts_facebook_path(@business), status: 303}
      format.json
    end
  end
  private

  def facebook_automation_params
    params.require(:business).permit(
      :automated_export_facebook_reviews,
    )
  end

  def facebook_id
    path = URI.parse(params[:business].try(:[], :facebook_id)).path rescue ''
    path.sub(/\A\//, '').split('/').first
  end
end
