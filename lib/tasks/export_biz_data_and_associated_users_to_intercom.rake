desc 'Export Biz Data and Associated Users to Intercom'
task export_biz_data_and_associated_users_to_intercom: [:environment] do
	Business.all.each do |biz|
		biz.update_intercom_company #creates or updates businesses
		biz.associate_users_with_intercom_company #on Intercom, associates users with businesses...
		#...just as they are associated on Impact's db
	end
end