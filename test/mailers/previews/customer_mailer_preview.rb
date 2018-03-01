class CustomerMailerPreview < ActionMailer::Preview
  include ActionView::Helpers::TextHelper

  def setup_preview
    unless @user = User.find_by(super_user: false)
      @user = PopulateUser.run
    end
    unless @business = @user.businesses.first
      @business = PopulateBusiness.run(@user)
    end
    @contact = @business.contacts.first || PopulateContact.run(@business)
    unless @feedback = @business.feedbacks.first
      @feedback = Feedback.create!(contact: @contact, business: @business)
    end
  end

  def feedback
    setup_preview
    CustomerMailer.feedback(@feedback)
  end
end
