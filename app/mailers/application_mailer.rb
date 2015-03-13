class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.secrets.support_email
  layout 'mailer'
end
