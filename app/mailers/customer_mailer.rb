class CustomerMailer < ApplicationMailer
  include WebsiteHelper

  def review_invitation(customer)
    @customer = customer
    @website_host = website_host(customer.business.website)
    mail to: @customer.email
  end
end
