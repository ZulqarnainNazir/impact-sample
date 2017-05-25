class ContactFormFormField < ActiveRecord::Base
  before_create :set_defaults
  default_scope { order('position') }
  belongs_to :contact_form
  belongs_to :form_field

  def set_defaults
    if self.form_field_id
      if FormField.find(self.form_field_id).required
        self.required = true
      end
    end
  end

  def label
    if self[:label].blank? && !self[:form_field_id].blank?
      FormField.find(self[:form_field_id]).label
    else
      self[:label]
    end
  end

end
