class Businesses::AffiliatePaymentsController < Businesses::BaseController

	before_action :ensure_admin, :only => [:unpaid_affiliate_commissions, :mark_as_paid]
	before_action :current_business
	before_action :load_subscription
	before_action :load_affiliate_payment, :except => [:unpaid_affiliate_commissions, :mark_as_paid]
	before_action :load_subscription_payment, :except => [:unpaid_affiliate_commissions, :mark_as_paid]
	layout 'business'

	def unpaid_affiliate_commissions
		@balance = AffiliatePayment.get_balance(@business.subscription_affiliate.id)
		@unpaid = AffiliatePayment.get_unpaid_for_affiliate(@business.subscription_affiliate.id)
	end

	def mark_as_paid
		@ids = params[:unpaid][:ids]
		@title = params['Title']
		@description = params['Description']
		@updates = AffiliatePayment.where("id IN (?)", @ids)

		if @title.empty? || @title.nil?
			@title = "Affiliate Commission Payment to #{@business.name}"
		end

		if @description.empty? || @description.nil?
			@description = "This commission was earned from a subscription payment made 
			by a business you referred to us."
		end

		if	@updates.update_all({paid: true, title: @title, description: @description})
			flash[:notice] = "Commissions are now marked as paid."
			redirect_to business_subscription_affiliate_sales_path(@business, @subscription)
		else
			flash[:notice] = "Update error. Please try again."
			render 'unpaid_affiliate_commissions'
		end	
	end

	def edit
		
	end

	def update
		if @affiliate_payment.update(affiliate_payment_params)
			flash[:notice] = "You've updated this Affiliate Payment."
			redirect_to business_subscription_affiliate_sales_path
		else
			flash[:notice] = "Update error. Please try again."
			render 'edit'
		end
	end

	protected


		def affiliate_payment_params
		    params.require(:affiliate_payment).permit(
		      :title, 
		      :description, 
		      :amount, 
		      :paid
		      )
		end

		def load_affiliate_payment
			@affiliate_payment = AffiliatePayment.find(params[:id])
		end

		def current_business
			@business
		end

		def load_subscription
			@subscription = current_business.subscription
		end

		def load_subscription_payment
			@sp = SubscriptionPayment.find_by(
				transaction_id: @affiliate_payment.subscription_payment.transaction_id
			)
		end

end