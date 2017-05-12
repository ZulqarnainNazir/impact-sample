class FormField < ActiveRecord::Base
  has_many :contact_form, :through => :contact_form_form_field
end
