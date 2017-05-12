class FormSubmission < ActiveRecord::Base
  after_create :send_notification
  belongs_to :contact_form
  belongs_to :form_field
  belongs_to :contact
  belongs_to :business
  has_many :form_submission_values

  def send_notification
    business.authorizations.includes(:user).where(contact_message_notifications: true).each do |authorization|
      AuthorizationsMailer.contact_form_submission_notification(authorization, self).deliver_later
    end
  end
end
