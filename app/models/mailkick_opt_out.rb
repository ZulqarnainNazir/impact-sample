class MailkickOptOut < ActiveRecord::Base
  #note: this is here only to access the MailKickOptOut records.
  # it is, in most cases, not meant to store methods related to the Mailkick gem. 
  # look at the gem's files and documentation here https://github.com/ankane/mailkick
  # to see how to do that in a way that aligns with how the gem was made and its uses.

  # before_save do
  # 	all = MailkickOptOut.where(email: self.email)
  # 	if all.count > 1
  # 		all.each do |n|
  # 			n.active = self.active
  # 			n.save
  # 		end
  # 	end
  # end



end
