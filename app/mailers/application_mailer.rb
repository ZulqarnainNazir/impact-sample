class ApplicationMailer < ActionMailer::Base
  add_template_helper(EmailHelper)
  default from: "Locable <#{Rails.application.secrets.support_email}>"
  layout 'mailer'

  def test(user)
  	mail to: user.email, subject: 'impact-test'
  end

  def test_two(email)
  	if email.nil?
	  	mail to: 'taylor.a.barnette@gmail.com', subject: 'sns-test'
	  else
      mail to: email, subject: 'sns-test'
	  end
  end

end
