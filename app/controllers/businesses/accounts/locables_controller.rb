class Businesses::Accounts::LocablesController < Businesses::BaseController
  before_action only: %i[edit update] do
    unless @business.cce_id?
      @locable_user = connect_to('/user', email: current_user.email)

      if @locable_user[:id]
        @locable_businesses_json = Array(connect_to('/businesses', email: current_user.email)[:businesses])
        @locable_sites_json = Array(connect_to('/sites')[:sites])
      end
    end
  end

  def update
    if params[:locable_id].present?
      locable_business = @locable_businesses_json.find { |json| json[:id].to_s == params[:locable_id] }
      if locable_business && @business.update(cce_id: locable_business[:id], cce_name: locable_business[:name], cce_url: locable_business[:locable_url])
        connect_to "/businesses/#{@business.cce_id}/link", impact_id: @business.id
        redirect_to [:edit, @business, :accounts_locable], notice: 'Your Locable account was successfully linked.'
      else
        redirect_to [:edit, @business, :accounts_locable], alert: 'There was a problem linking your Locable account.'
      end
    elsif params[:add_to_locable].present?
      payload = connect_to('/businesses/create_claim_link', email: current_user.email, site_id: params[:site_id], business: @business.as_json(include: { location: {}, categories: { only: :name }}))
      if payload[:id] && @business.update(cce_id: payload[:id], cce_name: payload[:name], cce_url: payload[:locable_url])
        redirect_to [:edit, @business, :accounts_locable], notice: 'Your Locable listing was successfully claimed.'
      else
        redirect_to [:edit, @business, :accounts_locable], alert: "There was a problem claiming your Locable listing – #{payload[:message]}"
      end
    else
      locable_slug = params[:locable_url].split('/').last.parameterize
      payload = connect_to("/businesses/#{locable_slug}/claim_link", id: @business.id, email: current_user.email)
      if payload[:id] && @business.update(cce_id: payload[:id], cce_name: payload[:name], cce_url: payload[:locable_url])
        redirect_to [:edit, @business, :accounts_locable], notice: 'Your Locable account was successfully linked.'
      else
        redirect_to [:edit, @business, :accounts_locable], alert: "There was a problem claiming your Locable listing – #{payload[:message]}"
      end
    end
  end

  def destroy
    cce_id = @business.cce_id
    if @business.update cce_id: nil, cce_name: nil, cce_url: nil
      connect_to "/businesses/#{cce_id}/unlink", impact_id: @business.id
      redirect_to [:edit, @business, :accounts_locable], notice: 'Your Locable account was successfully unlinked.'
    else
      redirect_to [:edit, @business, :accounts_locable], alert: 'There was a problem unlinking your Locable account.'
    end
  end
end
