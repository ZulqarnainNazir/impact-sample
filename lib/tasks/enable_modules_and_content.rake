desc 'Enable Modules and Content'
task enable_modules_and_content: [:environment] do
	Business.joins(:subscription).where("subscription_plan_id != ?", 1).each do |biz|
		count = [0, 1, 2, 3, 4, 5]
		content_type = [:post, :before_after, :event, :quick_post, :job, :offer, :gallery]
		count.each do |kind|
	        @module = AccountModule.new(kind: kind, active: true)
	        @module.business = biz
	        if kind == 1
	        	content_type.each do |content_type|
		        	@module.send("#{content_type}=", true)
		        end
		    end
	        @module.save
	    end
	end
end