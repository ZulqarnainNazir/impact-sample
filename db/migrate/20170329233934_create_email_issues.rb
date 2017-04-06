class CreateEmailIssues < ActiveRecord::Migration
  def change
    create_table :bounced_emails do |t|
    	t.text :bounce_type
    	t.text :email_address
    	t.text :status
    	t.text :action
    	t.text :diagnostic_code
    	t.text :reporting_mta
    	t.timestamps
    end
    create_table :complaints_emails do |t|
    	t.text :user_agent
    	t.text :email_address
    	t.text :complaint_feedback_type
    	t.text :feedback_id
    	t.timestamps
    end
  end
end