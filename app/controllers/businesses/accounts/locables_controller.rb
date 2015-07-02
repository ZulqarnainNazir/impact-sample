class Businesses::Accounts::LocablesController < Businesses::BaseController
  before_action do
    @locable_businesses_json = Array(connect_to('/businesses', email: current_user.email)[:businesses])
  end

  def update
    if params[:locable_id].present?
      locable_business = @locable_businesses_json.first { |json| json[:id].to_s == params[:locable_id] }
      if locable_business && @business.update(cce_id: locable_business[:id], cce_url: locable_business[:locable_url])
        connect_to "/businesses/#{@business.cce_id}/link", impact_id: @business.id
        redirect_to [:edit, @business, :accounts_locable], notice: 'Your Locable account was successfully linked.'
      else
        redirect_to [:edit, @business, :accounts_locable], alert: 'There was a problem linking your Locable account.'
      end
    elsif params[:add_to_locable].present?
      redirect_to [:edit, @business, :accounts_locable], alert: 'TODO'
    else
      locable_slug = params[:locable_url].split('/').last
      payload = connect_to("/businesses/#{locable_slug}", email: current_user.email)
      if payload[:id] && @business.update(cce_id: payload[:id], cce_url: payload[:locable_url])
        connect_to "/businesses/#{@business.cce_id}/link", impact_id: @business.id
        redirect_to [:edit, @business, :accounts_locable], notice: 'Your Locable account was successfully linked.'
      else
        redirect_to [:edit, @business, :accounts_locable], alert: 'Sorry, it looks like that page is missing or has a privacy setting that prevents us from importing data.'
      end
    end
  end

  def destroy
    cce_id = @business.cce_id
    if @business.update cce_id: nil, cce_url: nil
      connect_to "/businesses/#{cce_id}/unlink", impact_id: @business.id
      redirect_to [:edit, @business, :accounts_locable], notice: 'Your Locable account was successfully unlinked.'
    else
      redirect_to [:edit, @business, :accounts_locable], alert: 'There was a problem unlinking your Locable account.'
    end
  end
end
