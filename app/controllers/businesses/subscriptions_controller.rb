class Businesses::SubscriptionsController < Businesses::BaseController
	# before_action :authenticate_user!, :except => [ :new, :create, :plans, :canceled, :thanks]
	# before_action :authorized?, :except => [ :new, :create, :plans, :canceled, :thanks]
	# #====API
	# before_action :create_core_session_with_token!, :only => [:plans]
	# before_action :authenticate_user_on_core_with_token!
	# before_action :verify_authorization_to_manage_subscriptions, :only => [:plans]
	before_action :current_business
	before_action :load_billing, :only => [ :billing, :initial_billing_setup ]
	before_action :load_subscription, :only => [ :billing_history, :billing, :plan, :initial_billing_setup, :subscription_dashboard ]
	# #=====
	before_action :load_discount, :only => [ :plans, :plan, :new, :create ]

	skip_before_filter :raise_initial_billing_and_subscription_roadblock, :only => [ :create, :plan ]
	skip_before_filter :confirm_billing_information_present, :only => [ :create, :plan, :billing, :initial_billing_setup ]
	skip_before_filter :confirm_subscription_present, :only => [ :create, :plan ]

	layout 'business', :only => [:billing_history, :plans, :subscription_dashboard, :billing] #exceptions to this exist below in #initial_billing, etc.
	# before_action :build_plan, :only => [:new, :create]
	# before_action :build_account, :only => [:new, :create]
	# before_action :build_user, :only => [:new, :create]

	#API? before_action :collect_billing_info, :only => [:plan]

	# def new
	#   # render :layout => 'public' # Uncomment if your "public" site has a different layout than the one used for logged-in users
	# end

	#SET PERMISSIONS


	def billing_history
		@sp = @subscription.subscription_payments
	end


	def initial_plan_setup
		@plans = SubscriptionPlan.get_build_plans_with_setup_fees
		render action: "initial_plan_setup", layout: 'initial_plan_setup'
	# #initial_plan_setup and #initial_billing_setup are for new customers
	#going through the initial sign-up process.
		# if !current_business.subscription.present? || params[:back].present? && params[:back] == "true"
		# 	@subscription = Subscription.new
		# 	@plans = SubscriptionPlan.get_build_plans_with_setup_fees
		# 	if @plans.nil?
		# 		flash[:notice] = "Sorry, something went wrong! Please try again shortly."
		# 		redirect_to root_path
		# 	end
		# 	# render :layout => 'public' # Uncomment if your "public" site has a different layout than the one used for logged-in users
		# elsif current_business.subscription.present? && current_business.subscription.inactive? && !params[:back].present?
		# 	flash[:notice] = "Looks like we need your billing information to activate your subscription!"
		# 	redirect_to :action => "initial_billing_setup"
		# elsif current_business.subscription.present?
		# 	redirect_to :action => "subscription_dashboard"
		# end
		# render action: "initial_plan_setup", layout: 'initial_plan_setup'
	end

	def initial_billing_setup

		if !@subscription.upgrade_to.nil?
			@subscription_plan = SubscriptionPlan.find(@subscription.upgrade_to)
		else
			@subscription_plan = @subscription.plan
		end

		if @subscription.flagged_for_annual? && !@subscription.upgrade_to.nil? #|| @subscription.annual? && @subscription.upgrade_to.nil? && !@subscription.flagged_for_annual?
			@amount = @subscription_plan.amount_annual
		else
			@amount = @subscription_plan.amount
		end

		if request.post?

			result = if params[:stripeToken].present?
				@subscription.store_card(params[:stripeToken])
			else
				@address.first_name = @creditcard.first_name
				@address.last_name = @creditcard.last_name

				(@creditcard.valid? & @address.valid?) && @subscription.store_card(@creditcard, :billing_address => @address.to_activemerchant, :ip => request.remote_ip)
			end

			if result
				if @subscription_plan.setup_amount > 0
					flash[:notice] = "Congratulations! Your subscription is now 
					active, and your billing information has been added."
					StripeChargeNowJob.perform_now(@subscription.id)
					redirect_to :action => "subscription_dashboard" and return
				elsif
					flash[:notice] = "Thank you! Your new subscription is now 
					active, and your billing information has been saved."
					StripeChargeNowJobTwo.perform_now(@subscription.id)
					redirect_to :action => "subscription_dashboard" and return
				else
					flash[:notice] = "Something went wrong. Please try again."
				end
			end
		end

		render action: "initial_billing_setup", layout: 'initial_plan_setup'
	end

	#get the plans
	def plans
		if !current_business.subscription.present?
			@subscription = Subscription.new
			@plans = SubscriptionPlan.order('amount desc')
			# render :layout => 'public' # Uncomment if your "public" site has a different layout than the one used for logged-in users
		else
			redirect_to :action => "subscription_dashboard"
		end
	end

	#create a subscription for the current_business if the current_business has no plan.
	#if plan is present, redirect to plan for updating / other modifications
	def create
		if current_business.subscription.present? && current_business.subscription.inactive? && params[:subscription][:initial_billing_setup].present?
			@subscription = current_business.subscription
			@subscription.plan = SubscriptionPlan.find(params[:subscription][:subscription_plan_id])

			if @subscription.save
				# SubscriptionNotifier.plan_changed(@subscription).deliver
				redirect_to :action => "initial_billing_setup"
			else
				flash[:error] = "Error updating your plan: #{@subscription.errors.full_messages.to_sentence}"
				redirect_to :action => "initial_plan_setup"
			end
		elsif !current_business.subscription.present? && SubscriptionPlan.exists?(params[:subscription][:subscription_plan_id])
			@plan = SubscriptionPlan.find(params[:subscription][:subscription_plan_id])
			@subscription = Subscription.new
			@subscription.subscriber = current_business
			@subscription.plan = @plan


			if params[:subscription][:annual].present?
				if params[:subscription][:annual] == "true" && @subscription.annual == false
					@subscription.annual = true
					# if @subscription.next_renewal_at.nil?
					# 	@subscription.next_renewal_at = Time.now.advance(:years => 1)
					# else
					# 	@subscription.next_renewal_at = @subscription.next_renewal_at.advance(:years => 1)
					# end
					@subscription.amount = @plan.amount_annual
				elsif params[:subscription][:annual] == "false" && @subscription.annual == true
					@subscription.annual = false
					# if @subscription.next_renewal_at.empty?
					# 	@subscription.next_renewal_at = Time.now.advance(:months => 1)
					# else
					# 	@subscription.next_renewal_at = @subscription.next_renewal_at.advance(:months => 1)
					# end
					@subscription.amount = @plan.amount
				end
			end

			# @subscription = current_business.build_subscription(
			#   subscription_plan_id: @plan.id,
			#   subscriber_type: "Business",
			#   amount: @plan.amount,
			#   state: "active"
			#   )
			if @subscription.save
				if @subscription.inactive?
				   flash[:notice] = "Please enter your billing information to finish the subscription process."
				   redirect_to setup_billing_business_subscriptions_path
				elsif @subscription.needs_payment_info? && !@subscription.inactive?
					flash[:notice] = "Please enter your billing information to finish the subscription process."
					redirect_to setup_billing_business_subscriptions_path
				elsif !@subscription.needs_payment_info? && !@subscription.inactive?
					flash[:notice] = "You've successfully signed-up for the Free Plan. Thank you!"
					redirect_to :action => "subscription_dashboard"
				end
			else
				# render :action => 'edit'
				redirect_to :action => "subscription_dashboard"
			end
		else
			redirect_to plan_business_subscriptions_path
		end
	end

	def subscription_dashboard
		if SubscriptionPlan.any? && !@subscription.nil?
			@plans = SubscriptionPlan.where(['id <> ?', @subscription.subscription_plan_id]).order('amount desc').collect {|p| p.discount = @subscription.discount; p }
		end

		if !@subscription.nil? && !@subscription.downgrade_to.nil?
			@new_subscription = SubscriptionPlan.find(@subscription.downgrade_to).name
		end

		if @business.is_affiliate?
			@balance = AffiliatePayment.get_balance(@business.subscription_affiliate.id)
		end
	end

	#for modifying plan chosen in #plans. note that this is a post *and* get resource (see routes)
	def plan
		if request.post?
			@downgraded = false

			if params[:subscription].present?
				@plan = SubscriptionPlan.find(params[:subscription][:subscription_plan_id])
				if !@subscription.missing_any_payment_info?
					if @plan.is_engage_plan? && !@subscription.plan.is_engage_plan? 
						#if the user is downgrading 
						#(usually to Engage, i.e., the Free plan)
						@subscription.downgrade_to = @plan.id 
						@downgraded = true
					else
						@subscription.plan = @plan
						#ensures scheduled downgrade is removed in case user upgraded to new
						#plan before subscription was downgraded
						@subscription.downgrade_to = nil

						if params[:subscription][:annual].present?
							if params[:subscription][:annual] == "true" && @subscription.annual == false
								@subscription.annual = true
								# if @subscription.next_renewal_at.nil?
								# 	@subscription.next_renewal_at = Time.now.advance(:years => 1)
								# else
								# 	@subscription.next_renewal_at = @subscription.next_renewal_at.advance(:years => 1)
								# end
								@subscription.amount = @plan.amount_annual
							elsif params[:subscription][:annual] == "false" && @subscription.annual == true
								@subscription.annual = false
								# if @subscription.next_renewal_at.empty?
								# 	@subscription.next_renewal_at = Time.now.advance(:months => 1)
								# else
								# 	@subscription.next_renewal_at = @subscription.next_renewal_at.advance(:months => 1)
								# end
								@subscription.amount = @plan.amount
							end
						end
					end
				elsif @subscription.missing_any_payment_info?
					@subscription.upgrade_to = @plan.id
					if params[:subscription][:annual].present? && params[:subscription][:annual] == "true"
						@subscription.flagged_for_annual = true
					else
						@subscription.flagged_for_annual = false
					end
				end
			end

			if params[:revert].present?
				@subscription.downgrade_to = nil
			end

			if @subscription.save
				if @downgraded == true
					SubscriptionNotifier.downgrade_free_notification(@subscription).deliver_later(wait: 5.seconds)
				end
				if !@subscription.missing_any_payment_info? 
					flash[:notice] = "Your subscription has been changed."
					redirect_to :action => "subscription_dashboard"
				elsif @subscription.missing_any_payment_info?
					flash[:notice] = "Please enter your billing information to finish the subscription process."
					redirect_to :action => "initial_billing_setup"
				end
			else
				if @subscription.errors.any?
					flash[:notice] = "Error updating your plan: #{@subscription.errors.full_messages.to_sentence}"
				else
					flash[:notice] = "Something went wrong. Please try again later."
				end
				redirect_to :action => "subscription_dashboard"
			end
		else
			@subscription_plan_free = SubscriptionPlan.engage_plan
			@subscription_plan_build = SubscriptionPlan.build_plan_with_no_setup_fee.first
			render action: "plan", layout: 'initial_plan_setup'
			# @plans = SubscriptionPlan.where(['id <> ?', @subscription.subscription_plan_id]).order('amount desc').collect {|p| p.discount = @subscription.discount; p }
		end
	end

	def billing
		#handles storage (including changing) of billing information, but does not
		#initiate an immediate charge.
		if request.post?
			result = if params[:stripeToken].present?
				@subscription.store_card(params[:stripeToken])
			else
				@address.first_name = @creditcard.first_name
				@address.last_name = @creditcard.last_name

				(@creditcard.valid? & @address.valid?) && @subscription.store_card(@creditcard, :billing_address => @address.to_activemerchant, :ip => request.remote_ip)
			end

			if result
				SubscriptionNotifier.billing_info_updated(@subscription).deliver_later(wait: 5.seconds)
				flash[:notice] = "Your billing information has been updated."
				redirect_to :action => "subscription_dashboard"
			end
		end
	end

	protected

		def current_business
			@business
		end

		def redirect_url
			{ :action => 'subscription_dashboard' }
		end

		def load_billing
			#if you're getting weird errors related to this method, or I18n::InvalidLocaleData,
			#check to make sure that indentation/spacing in your editor is done with tabs, not spaces. 
			#yml flips-out if indentation/spacing not done with tabs.
			#http://stackoverflow.com/questions/15331873/error-i18ninvalidlocaledata
			@creditcard = ActiveMerchant::Billing::CreditCard.new(params[:creditcard] || {})
			@address = SubscriptionAddress.new(params[:address])
		end

		def load_subscription
			@subscription = current_business.subscription
		end

		# Load the discount by code, but not if it's not available
		def load_discount
			if params[:discount].blank? || !(@discount = SubscriptionDiscount.find_by_code(params[:discount])) || !@discount.available?
				@discount = nil
			end
		end

		def authorized?
			redirect_to new_user_session_url unless self.action_name == 'dashboard' || admin?
		end

		def set_subscription_params
			params.require(:subscription).permit(
				:name
			)
		end

end
