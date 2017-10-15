class AhoyMessage < ActiveRecord::Base

  def bounce_report
    bounce_report = BouncedEmail.find_by(email_address: self.to)
    if bounce_report.nil?
      'none'
    elsif !bounce_report.nil?
      bounce_report.bounce_type
    end
  end

  def complaint_report
    complaint_report = ComplaintsEmail.find_by(email_address: self.to)
    if complaint_report.nil?
      'none'
    elsif !complaint_report.nil?
      complaint_report.complaint_feedback_type
    end
  end

  def self.invite_sent_check?(user_id, email)
    #checks to see if user sent email, even if they removed contact
    emails = AhoyMessage.where(user_id: user_id, to: email)
    if !emails.empty?
      emails.each do |record|
        if record.mailer.include?("InvitesMailer")
          return true
        end
      end
      return false
    else
      return false
    end
  end

  def invite_calculator
    return AhoyMessage.where(user_id: self.user_id, to: self.to, mailer: self.mailer).count
    #AhoyMessage.where(user_id: 1000, to: "self.to", mailer: "self.mailer").count
  end

  def feedback_calculator
    return AhoyMessage.where(user_id: self.user_id, to: self.to, mailer: self.mailer).count
    #AhoyMessage.where(user_id: 1000, to: "self.to", mailer: "self.mailer").count
  end

  def was_feedback_email?
    if self.mailer == "CustomerMailer#feedback"
      return true
    else
      return false
    end
  end

  def was_invite_email?
    if self.mailer == "InvitesMailer#quick_invite" || self.mailer == "InvitesMailer#basic_invite" || self.mailer == "InvitesMailer#member_invite" || self.mailer == "InvitesMailer#member_invite_two"
      return true
    else
      return false
    end
  end

  def created_at
    self.sent_at
  end

end