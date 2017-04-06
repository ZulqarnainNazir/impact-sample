require 'json'
class BouncedEmail < ActiveRecord::Base
  before_create :set_to_string #we use before_create because we want this to fire *only* on create operations,
  #not on update operations, which before_save will do

  def set_to_string
    if !self.email_address.nil?
      self.email_address = JSON.parse(self.email_address).pop
    end
    if !self.status.nil?
      self.status = JSON.parse(self.status).pop
    end
    if !self.action.nil?
      self.action = JSON.parse(self.action).pop
    end
    if !self.diagnostic_code.nil?
      self.diagnostic_code = JSON.parse(self.diagnostic_code).pop
    end
  end
end
