class AccountMailerPreview < ActionMailer::Preview
  include ActionView::Helpers::TextHelper

  def setup_preview
    unless @user = User.find_by(super_user: false)
      @user = PopulateUser.run
    end
  end

  def confirmation_instructions
    setup_preview
    AccountMailer.confirmation_instructions(@user, '1f28a396b9451f722fbeb96396bac0804e')
  end
end
