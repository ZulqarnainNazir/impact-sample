class Super::SubscriptionsDataController < SuperController
  def subscription_stats

  end

  def subscriber_states
    @subscriptions = Subscription.order("id").page(params[:page]).per(5)
    respond_to do |format|
      format.html
      format.json
    end
  end

  def subscriber_basic_info
    respond_to do |format|
      format.html
      format.json
    end
  end

  def inactive_subscriptions
    @inactive_subscriptions = Subscription.inactive_subscriptions
    respond_to do |format|
      format.js
    end
  end

  private

end