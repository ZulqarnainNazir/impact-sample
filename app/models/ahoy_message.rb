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

  def created_at
    self.sent_at
  end

end