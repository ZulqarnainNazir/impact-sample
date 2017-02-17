class Businesses::AffiliateSalesController < Businesses::BaseController
	before_action :current_business
	before_action :load_subscription
	before_action :load_payment, :only => [:show]
	layout 'business'

	def index
		@balance = AffiliatePayment.get_balance(@business.subscription_affiliate.id)
		@affiliate_sales = @business.subscription_affiliate.subscription_payments
		@referred_businesses = Business.get_referred_businesses(current_business.subscription_affiliate.id)
	end

	def show
		@subscriber = @sp.subscriber
	end

	# #commissions and #referred_businesses are for jquery
	def commissions
	    @affiliate_sales = @business.subscription_affiliate.subscription_payments
	    respond_to do |format|
	      format.js
	    end
	end

	def referred_businesses
	    @referred_businesses = Business.get_referred_businesses(current_business.id)
	    respond_to do |format|
	      format.js
	    end
	end

	protected

		def current_business
			@business
		end

		def load_subscription
			@subscription = current_business.subscription
		end

		def load_payment
			@sp = SubscriptionPayment.find_by(transaction_id: params[:id])
		end

end