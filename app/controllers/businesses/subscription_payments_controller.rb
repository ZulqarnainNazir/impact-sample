class Businesses::SubscriptionPaymentsController < Businesses::BaseController
	before_action :set_subscription_payment, :only => [:show]
	before_action :current_business, :only => [:show]
	layout 'business'

	def show

	end

	protected

		def set_subscription_payment
			@sp = SubscriptionPayment.find_by(transaction_id: params[:id])
		end

		def current_business
			@business
		end

		def load_subscription
			@subscription = current_business.subscription
		end

end