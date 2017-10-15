class Invite < ActiveRecord::Base
  belongs_to :invitee,
    class_name: 'Contact'
  belongs_to :inviter,
    class_name: 'User'
  belongs_to :company

  def send_member_invite(sending_biz)
    begin
    	@business = sending_biz
    	InvitesMailer.member_invite(self, @business).deliver_later(wait: 5.seconds)
    	InvitesMailer.member_invite(self, @business).deliver_later(wait: 3.days)
    	InvitesMailer.member_invite(self, @business).deliver_later(wait: 1.week)
      return true
    rescue
      return false
    end
  end

  def send_basic_invite(sending_biz)
    begin
    	@business = sending_biz
    	InvitesMailer.basic_invite(self, @business).deliver_later(wait: 5.seconds)
    	InvitesMailer.basic_invite(self, @business).deliver_later(wait: 3.days)
    	InvitesMailer.basic_invite(self, @business).deliver_later(wait: 1.week)
      return true
    rescue
      return false
    end
  end

  def send_member_invite_2(sending_biz)
    begin
    	@business = sending_biz
    	InvitesMailer.member_invite_2(self, @business).deliver_later(wait: 5.seconds)
    	InvitesMailer.member_invite_2(self, @business).deliver_later(wait: 3.days)
    	InvitesMailer.member_invite_2(self, @business).deliver_later(wait: 1.week)
      return true
    rescue
      return false
    end
  end

end
