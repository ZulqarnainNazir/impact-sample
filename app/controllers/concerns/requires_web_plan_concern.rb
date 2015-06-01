module RequiresWebPlanConcern
  extend ActiveSupport::Concern

  included do
    before_action do
      if @business.free?
        redirect_to [@business, :dashboard], alert: 'Please Upgrade to a Web or Primary subscription to access that feature.'
      end
    end
  end
end
