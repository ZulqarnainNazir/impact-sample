class AccountMailer < Devise::Mailer
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers
  def confirmation_instructions(record, token, opts={})
    opts[:subject] = "#{record.name}, Confirm your account in Locable's Marketing Platform"
    super
  end
end
