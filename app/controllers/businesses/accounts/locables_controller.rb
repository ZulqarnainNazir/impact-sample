class Businesses::Accounts::LocablesController < Businesses::BaseController
  before_action only: %i[edit update] do
    if @business.cce_id?
      @locable_business = LocableBusiness.find_by_id(@business.cce_id)
    end

    unless @locable_business
      @locable_user = LocableUser.find_by_email(current_user.email)

      if @locable_user
        @locable_businesses = @locable_user.businesses.to_a + @locable_user.managed_businesses.to_a
        @locable_sites = LocableSite.order(name: :asc).to_a
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
        if locable_business && locable_business.link(@business, current_user, @locable_user)
          redirect_to [:edit, @business, :accounts_locable], notice: 'Your Locable account was successfully linked.'
        else
          redirect_to [:edit, @business, :accounts_locable], alert: 'There was a problem linking your Locable account.'
        end
      elsif params[:add_to_locable].present?
        locable_site = @locable_sites.find { |record| record.id.to_s == params[:site_id] }
        if locable_site
          locable_business = LocableBusiness.new
          if locable_business.create(@business, current_user, @locable_user, locable_site)
            redirect_to [:edit, @business, :accounts_locable], notice: 'Your Locable account was successfully created.'
          else
            redirect_to [:edit, @business, :accounts_locable], alert: 'There was a problem creating your Locable business.'
          end
        else
          redirect_to [:edit, @business, :accounts_locable], alert: 'Please provide a valid Locable site.'
        end
      else
        locable_slug = params[:locable_url].to_s.split('/').last
        locable_business = LocableBusiness.find_by_slug(locable_slug)
        if locable_slug.present? && locable_business
          if locable_business.claimed?
            if current_user.super_user? || locable_business.users.include?(@locable_user) || @locable_user.businesses.include?(current_user)
              if locable_business.link(@business, current_user, @locable_user)
                redirect_to [:edit, @business, :accounts_locable], notice: 'Your Locable account was successfully linked.'
              else
                redirect_to [:edit, @business, :accounts_locable], alert: 'There was a problem linking your Locable listing.'
              end
            else
              redirect_to [:edit, @business, :accounts_locable], alert: 'It looks like that listing has already been claimed.'
            end
          else
            if locable_business.claim(@business, current_user, @locable_user)
              redirect_to [:edit, @business, :accounts_locable], notice: 'Your Locable account was successfully claimed.'
            else
              redirect_to [:edit, @business, :accounts_locable], alert: 'There was a problem claiming your Locable listing.'
            end
          end
        else
          redirect_to [:edit, @business, :accounts_locable], alert: 'We could not find that business.'
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
