class Super::SubscriptionsDataController < SuperController
  layout 'businesses'
  def subscription_stats

  end

  def subscriptions
    @subscriptions = Subscription.includes( { subscriber: [:subscription_affiliate, :owners] }, :subscription_plan).order("id" => :desc).search(params[:search], params[:constraint]) #.page(params[:page]).per(20)
  end

  def all_subscriptions
    @subscriptions = Subscription.order("id").search(params[:search], params[:constraint]).page(params[:page]).per(20)
    respond_to do |format|
      format.js
    end
  end

  def past_dues
    @subscriptions = Subscription.search(params[:search], params[:constraint]).get_past_dues
    respond_to do |format|
      format.js
    end
  end

  def subscriber_basic_info
    respond_to do |format|
      format.html
      format.js
    end
  end

  def inactive_subscriptions
    @subscriptions = Subscription.search(params[:search], params[:constraint]).inactive_subscriptions
    respond_to do |format|
      format.js
    end
  end

  private

end
