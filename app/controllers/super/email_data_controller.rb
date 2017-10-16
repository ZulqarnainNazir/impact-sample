class Super::EmailDataController < SuperController
  layout 'businesses'
  before_action :set_emails, only: :index

  def index
    render json: @emails.as_json(only: [:sent_at, :to, :user_id, :bounced_report,
                                        :complaints_report, :opened_at, :clicked_at,
                                        :subject, :mailer])
  end

  def overview
  end

  private

  def set_emails
    @emails = AhoyMessage
      .joins('LEFT JOIN bounced_emails be ON be.email_address = ahoy_messages.to')
      .joins('LEFT JOIN complaints_emails ce ON ce.email_address = ahoy_messages.to')
      .select("*")
      .select("COALESCE(be.bounce_type,'none') AS bounced_report")
      .select("COALESCE(ce.complaint_feedback_type,'none') AS complaints_report")
      .order("sent_at DESC")
  end
end
