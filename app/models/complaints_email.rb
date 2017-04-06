class ComplaintsEmail < ActiveRecord::Base
  before_create :set_to_string #we use before_create because we want this to fire *only* on create operations,
  #not on update operations, which before_save will do

  def set_to_string
  	if !self.email_address.nil?
		self.email_address = JSON.parse(self.email_address).pop
	end
  end

end