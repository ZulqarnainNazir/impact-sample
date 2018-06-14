class FollowerNotificationMailer < ApplicationMailer
  include ActionView::Helpers::TextHelper
  layout 'mailer_theme_three'

  def new_follower(args)
    @user = args[:user]
    @business = args[:business]
    @follower_business = args[:follower_business]

    subject_biz = sanitize(@follower_business.name).truncate(50, separator: ' ')

    send_to(@user.email, "\"#{subject_biz}\" added you to their Local Network!")
  end

  def summary_email(args)
    @user = args[:user]
    @business = args[:business]
    @follower_businesses = args[:follower_businesses]

    @who = @follower_businesses.length === 1 ? 'A new business' :
      "#{@follower_businesses.length} new businesses"

    send_to(@user.email, "#{@who} added you to their Local Network")
  end

  private

  def send_to(email, subject)
    mail(
      to: email,
      from: "Buzz at Locable <#{Rails.application.secrets.buzz_email}>",
      subject: subject
    )
  end
end
