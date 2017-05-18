class FormSubmissionValue < ActiveRecord::Base
  belongs_to :form_submission
  belongs_to :contact_form_form_field
  has_one :form_field, through: :contact_form_form_field
end
