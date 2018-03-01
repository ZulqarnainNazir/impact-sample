class InvitesMailerPreview < ActionMailer::Preview
  include ActionView::Helpers::TextHelper

  def setup_preview
    unless @user = User.find_by(super_user: false)
      @user = PopulateUser.run
    end
    unless @business = @user.businesses.first
      @business = PopulateBusiness.run(@user)
    end
    @contact = @business.contacts.first || PopulateContact.run(@business)
    unless @invite = Invite.find_by(company: @business.company)
      @invite = PopulateInvite.run(@contact, @user, @business.company)
    end
  end

  def quick_invite
    setup_preview
    InvitesMailer.quick_invite(@invite, @business)
  end

  def basic_invite
    setup_preview
    InvitesMailer.basic_invite(@invite, @business)
  end

  def member_invite
    setup_preview
    InvitesMailer.member_invite(@invite, @business)
  end
end
