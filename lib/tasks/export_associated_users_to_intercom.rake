desc 'Export Associated Users to Intercom'
task export_associated_users_to_intercom: [:environment] do
	intercom = Intercom::Client.new(token: ENV['intercom_access_token'])
	Business.all.each do |biz|
	    biz.users.each do |user|
		    intercom.users.create(
		      :email => user.email,
		      :user_id => user.id,
		      :name => user.name,
		      :companies => [{:company_id=> biz.id}]
		    )
		    if not intercom.rate_limit_details[:remaining].nil? and intercom.rate_limit_details[:remaining] < 5
		      sleep_time = intercom.rate_limit_details[:reset_at].to_i - Time.now.to_i
		      puts("Waiting for #{sleep_time} seconds to allow for rate limit to be reset")
		      sleep sleep_time
		    end
	    end
	end
end