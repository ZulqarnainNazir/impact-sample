desc 'Export Biz Data to Intercom'
task export_biz_data_to_intercom: [:environment] do
	intercom = Intercom::Client.new(token: ENV['intercom_access_token'])
	Business.all.each do |biz|
	     plan_name = "none"
	     plan_change_date = "none"
	     landing_page = false
	     biz_company = "none"
	     sent_member_invite = "none"
	     if biz.website
            landing_page = biz.website.try(:webpages)
            landing_page = landing_page ? !landing_page.empty? : false
         end
	     if biz.has_plan?
	       plan_name = biz.subscription.plan.name
	       plan_change_date = biz.subscription.updated_at
	     end
	     hours = "N/A"
	     if biz.location.present? && biz.location.openings.present?
	       hours = biz.location.openings.first.hours
	     end
         if biz.company.present?
           sent_member_invite = Invite.where(company_id: biz.company.id, invite_as_member: true).present?
	     end
	    intercom.companies.create(
	    	 # :account_id => biz.id,
	         :company_id => biz.id,
	         :name => biz.name,
	         :plan => plan_name,
	         :website => biz.website_url,
	         :custom_attributes => {
	           :plan_change_date => plan_change_date,
	           #business attributes
	           :has_logo => biz.logo_placement.present?,
	           :hours_of_operation => hours,
	           :description => biz.description.present? ? biz.description.truncate(200) : "N/A", #truncated due to Intercom limit of 255 characters;
	           :membership_org => biz.membership_org,
	           :account_create_date => biz.created_at,
	           :account_claim_date => biz.created_at,
	            # todos
	           :to_dos_enabled => biz.to_dos_enabled,
	           :has_to_dos_enabled => biz.to_dos_enabled,

	           #modules
	           # :activated_mission_count => biz.missions.where(status: "active").count,
	           # :marketing_missions_module => biz.module_active?(0),
	           # :content_engine_module => biz.module_active?(1),
	           # :local_connections_module => biz.module_active?(2),
	           # :customer_reviews_module => biz.module_active?(3),
	           # :form_builder_module => biz.module_active?(4),
	           # :website_module => biz.module_active?(5),

	            #CRM stuff
	           :landing_page_count => biz.count_landing_pages,
	           :contact_form_count => biz.contact_forms.count,
	           :forms_submissions_count => biz.count_contact_forms_submissions,
	           :company_lists_count => biz.company_lists.count, #number of networks
	           :companies_in_crm_count => biz.owned_companies.count, #number of companies in networks
	           :contacts_in_crm_count => biz.contacts.count, #number of people in networks
	           :directory_count => biz.directory_widgets.count, #number of directories
	           :calendar_count => biz.calendar_widgets.count, #number of calendars
	           :reviews_requested_total => biz.feedbacks.count, #number of feedback reviews requested
	           :reviews_received_total => biz.reviews.count,
	           :form_count => biz.contact_forms.size,
	           :form_submissions_count => biz.form_submissions.size,
	           :company_contacts_count => biz.owned_companies.size,
	           :people_contacts_count => biz.contacts.size,
	           :company_list_count => biz.company_lists.size,
	           :membership_org => biz.membership_org,

	           #website stuff
	           :created_landing_page => landing_page,
	           :is_affiliate => biz.is_affiliate?,
	           :created_directory_widget => biz.directory_widgets.empty?,
	           :created_reviews_widget => biz.review_widgets.empty?,
	           :custom_primary_domain_in_use => (biz.website && biz.website.webhosts.any?),

	           #invites
		       :sent_member_invite => sent_member_invite,

	           #marketing missions
	           :assigned_marketing_mission => MissionInstance.where(business_id: biz.id).any?,


	            #social media stuff
	           :facebook_id => biz.facebook_id,
	           :google_plus_id => biz.google_plus_id,
	           :linkedin_id => biz.linkedin_id,
	           :twitter_id => biz.twitter_id,
	           :youtube_id => biz.youtube_id,
	           :instagram_id => biz.instagram_id,
	           :pinterest_id => biz.pinterest_id,
	           :yelp_id => biz.yelp_id,
	           :cce_id => biz.cce_id,
	           :zillow_id => biz.zillow_id,
	           :opentable_id => biz.opentable_id,
	           :trulia_id => biz.trulia_id,
	           :realtor_id => biz.realtor_id,
	           :tripadvisor_id => biz.tripadvisor_id,
	           :houzz_id => biz.houzz_id,
	         }
	    )
	    if not intercom.rate_limit_details[:remaining].nil? and intercom.rate_limit_details[:remaining] < 5
	      sleep_time = intercom.rate_limit_details[:reset_at].to_i - Time.now.to_i
	      puts("Waiting for #{sleep_time} seconds to allow for rate limit to be reset")
	      sleep sleep_time
	    end
	end
end
