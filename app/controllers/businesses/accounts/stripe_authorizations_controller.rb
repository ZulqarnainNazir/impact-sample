# Documentation: https://stripe.com/docs/connect/standard-accounts#redirected
class Businesses::Accounts::StripeAuthorizationsController < ApplicationController
  before_filter :stripe_init

  def update
    unless params[:error]
      business = Business.find(params[:state])

      begin
        response = @stripe.authorize_connect_account(params[:code])

        # Access the connected account id and refresh token in the response
        business.stripe_connected_account_id = response.stripe_user_id
        business.stripe_connected_account_refresh_token = response.refresh_token

        if business.save!
          redirect_to business_accounts_root_path(business), notice: "Your Stripe account has been connected."
        end

      rescue Stripe::StripeError => e
        redirect_to business_accounts_root_path(business), notice: "There was an error authorizing your account: #{e.message}"
      end

    else
      redirect_to business_accounts_root_path(business), notice: "Request cancelled."
    end
  end

  def destroy
    business = Business.find(params[:business])

    @stripe.deauthorize_connect_account(business)

    if business.update_attributes(stripe_connected_account_id: nil, stripe_connected_account_refresh_token: nil)
      redirect_to business_accounts_root_path(business), notice: "Your Stripe account has been disconnected."
    else
      redirect_to business_accounts_root_path(business), notice: "There was an error disconnecting your Stripe account."
    end

  end

  private

  def stripe_init
    @stripe = StripeService.new(request)
  end

end
