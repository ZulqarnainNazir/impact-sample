class AccountMailer < Devise::Mailer
  add_template_helper(EmailHelper)
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers

  layout 'mailer_theme_three'

  def confirmation_instructions(record, token, opts={})
    opts[:subject] = "#{record.name}, Confirm your account in Locable's Marketing Platform"
    super
  end
end
