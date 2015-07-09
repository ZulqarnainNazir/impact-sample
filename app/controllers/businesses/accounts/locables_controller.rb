class Businesses::Accounts::LocablesController < Businesses::BaseController
  before_action only: %i[edit update] do
    if @business.cce_id?
      @locable_business = LocableBusiness.find_by_id(@business.cce_id)
    end

    unless @locable_business
      @locable_user = LocableUser.find_by_email(current_user.email)

      if @locable_user
        @locable_businesses = @locable_user.businesses.to_a + @locable_user.managed_businesses.to_a
        @locable_sites = LocableSite.all.to_a
      end
    end
  end

  def update
    if @locable_business
      update_resource @business, locable_params, location: [:edit, @business, :accounts_locable] do |success|
        if success
          if @business.automated_export_locable_events == '1'
            EventsExportJob.perform_later(@business)
          end
          if @business.automated_export_locable_reviews == '1'
            ReviewsExportJob.perform_later(@business)
          end
          if @business.automated_import_locable_reviews == '1'
            ReviewsImportJob.perform_later(@business)
          end
        end
      end
    else
      if params[:locable_id].present?
        locable_business = @locable_businesses.find { |record| record.id.to_s == params[:locable_id] }
        if locable_business && locable_business.link(@business)
          redirect_to [:edit, @business, :accounts_locable], notice: 'Your Locable account was successfully linked.'
        else
          redirect_to [:edit, @business, :accounts_locable], alert: 'There was a problem linking your Locable account.'
        end
      elsif params[:add_to_locable].present?
        locable_site = @locable_sites.find { |record| record.id.to_s == params[:site_id] }
        locable_business = LocableBusiness.new
        if locable_site && locable_business.create(@business, current_user, locable_site)
          redirect_to [:edit, @business, :accounts_locable], notice: 'Your Locable listing was successfully claimed.'
        else
          redirect_to [:edit, @business, :accounts_locable], alert: 'There was a problem claiming your Locable listing.'
        end
      else
        locable_business = LocableBusiness.find_by_slug(params[:locable_url])
        if locable_business
          if locable_business.claimed?
            if locable_business.claim(@business, current_user)
              redirect_to [:edit, @business, :accounts_locable], notice: 'Your Locable account was successfully linked.'
            else
              redirect_to [:edit, @business, :accounts_locable], alert: 'There was a problem claiming your Locable listing.'
            end
          else
            if locable_business.link(@business)
              redirect_to [:edit, @business, :accounts_locable], notice: 'Your Locable account was successfully linked.'
            else
              redirect_to [:edit, @business, :accounts_locable], alert: 'There was a problem claiming your Locable listing.'
            end
          end
        else
          redirect_to [:edit, @business, :accounts_locable], alert: 'There was a problem claiming your Locable listing.'
        end
      end
    end
  end

  def destroy
    locable_business = LocableBusiness.find(@business.cce_id)

    if locable_business && locable_business.unlink(@business)
      redirect_to [:edit, @business, :accounts_locable], notice: 'Your Locable account was successfully unlinked.'
    else
      redirect_to [:edit, @business, :accounts_locable], alert: 'There was a problem unlinking your Locable account.'
    end
  end

  private

  def locable_params
    params.require(:business).permit(
      :automated_export_locable_events,
      :automated_export_locable_reviews,
      :automated_import_locable_events,
      :automated_import_locable_reviews,
    )
  end
end
