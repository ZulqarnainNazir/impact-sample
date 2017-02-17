class Super::AffiliatesController < SuperController
  layout 'businesses'

  def index
    @affiliates = SubscriptionAffiliate.order("id").page(params[:page]).per(20)
  end


  private


end