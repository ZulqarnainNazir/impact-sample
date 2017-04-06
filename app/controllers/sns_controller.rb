require 'json'
require 'httparty'

class SnsController < BaseApiController
  skip_before_action :verify_authenticity_token
  before_action :get_message_type_and_topic

  def bounce_data
    if @request_message['bounce'].present?
      recipients = @request_message['bounce']['bouncedRecipients']
      recipients.each do |n|
        BouncedEmail.create(
          bounce_type: @request_message['bounce']['bounceType'],
          email_address: n.values_at("emailAddress"),
          status: n.values_at('status'),
          action: n.values_at('action'),
          diagnostic_code: n.values_at('diagnosticCode'),
          reporting_mta: @request_message['bounce']['reportingMTA']
        )
      end
      render nothing: true, status: 200
    else
      return @return_message
    end
  end

  def report_data
    if @request_message['complaint'].present?
      recipients = @request_message['complaint']['complainedRecipients']
      email_addys = []
      recipients.each do |n|
        email_addys << n.values
      end
      email_addys.each do |n|
        @complaint = ComplaintsEmail.create(
          user_agent: @request_message['complaint']['userAgent'],
          email_address: n,
          complaint_feedback_type: @request_message['complaint']['complaintFeedbackType'],
          feedback_id: @request_message['complaint']['feedbackId']
        )
      end
      render nothing: true, status: 200
    else
      return @return_message
    end
  end

  private
    def get_message_type_and_topic
      amz_message_type = request.headers['x-amz-sns-message-type']
      amz_sns_topic = request.headers['x-amz-sns-topic-arn']

      return unless !amz_sns_topic.nil? && (amz_sns_topic.to_s.downcase == ENV['AWS_SNS_TOPIC_ARN_BOUNCE_DATA'] || amz_sns_topic.to_s.downcase == ENV['AWS_SNS_TOPIC_ARN_REPORT_DATA'])
      
      @request_body = JSON.parse(request.body.read)

      if amz_message_type.to_s.downcase == "subscriptionconfirmation"
        confirm_subscription_to_sns_topic(@request_body)
      else
        @request_message = JSON.parse(@request_body["Message"])
      end

    end

    def confirm_subscription_to_sns_topic(body)
      send_subscription_confirmation(body)
      return
    end

    def send_subscription_confirmation(body)
      subscribe_url = body['SubscribeURL']
      return nil unless !subscribe_url.to_s.empty? && !subscribe_url.nil?
      #ApplicationMailer.test_two.deliver_now
      #ApplicationMailer.test_two('bounce@simulator.amazonses.com').deliver_now
      #ApplicationMailer.test_two('complaint@simulator.amazonses.com').deliver_now
      subscribe_confirm = HTTParty.get(subscribe_url)
    end
end