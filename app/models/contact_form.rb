class ContactForm < ActiveRecord::Base
  after_initialize :init
  belongs_to :business
  has_many :contact_form_form_fields
  has_many :form_fields, :through => :contact_form_form_fields
  accepts_nested_attributes_for :contact_form_form_fields, allow_destroy: true, reject_if: proc { |a|
    a['_destroy'] == '1'
  }

  def init
    self.uuid ||= SecureRandom.uuid
  end

end
