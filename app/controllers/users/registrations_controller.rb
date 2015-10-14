class Users::RegistrationsController < Devise::RegistrationsController
  before_action only: %i[update] do
    %i[app_marketing_reminders email_marketing_reminders].each do |attribute|
      devise_parameter_sanitizer.for(:account_update) << attribute
    end
  end
end
