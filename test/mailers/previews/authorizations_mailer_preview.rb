class AuthorizationsMailerPreview < ActionMailer::Preview
  include ActionView::Helpers::TextHelper

  def setup_preview
    unless @user = User.find_by(super_user: false)
      @user = PopulateUser.run
    end
    unless @business = @user.businesses.first
      @business = PopulateBusiness.run(@user)
    end
    @authorization = @business.authorizations.first
  end

  def review_notification
    setup_preview
    @review = PopulateReview.run(@business)
    AuthorizationsMailer.review_notification(
      @authorization,
      @review
    )
  end

  def contact_form_submission_notification
    setup_preview
    @form_submission = PopulateFormSubmission.run(@business)
    AuthorizationsMailer.contact_form_submission_notification(
      @authorization,
      @form_submission
    )
  end
end
