module RequiresWebPlanConcern
  extend ActiveSupport::Concern

  included do
    before_action do
		unless current_user.super_user?
			if @business.is_on_engage_plan?
			    redirect_to [@business, :dashboard], alert: 'Please Upgrade Your Plan to Access That Feature.'
			end
		end
    end
  end
end
