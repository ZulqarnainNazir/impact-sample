namespace :create_companies do
  desc "Setup companies based on contacts built in business fields"
  task :from_contacts => :environment do
    Contact.all.each do |contact|
      if contact.business_client && !contact.business_name.blank?
        params = {:name => contact.business_name, :website_url => contact.business_url}
        puts "Adding company #{contact.business_name} to #{contact.name}"
        company = Company.create_with_associations(params, Business.find(contact.business_id))
        contact_company = ContactCompany.new(:contact_id => contact.id, :company_id => company.id)
        contact_company.save
        contact.reviews.each do |review|
          review.update_attributes(:company_id => company.id)
        end
        contact.feedbacks.each do |feedback|
          feedback.update_attributes(:company_id => company.id)
        end
        TrackRakeCreateCompany.create(:company_id => company.id, :company_location_id => company.company_location.id, :business_id => company.business.id, :location_id => company.business.location.id, :contact_company_id => contact_company.id)
      end
    end
  end
  desc "Rollback all the companies created from contact business info"
  task :rollback_import => :environment do
    TrackRakeCreateCompany.all.each do |company|
      Location.find(company.location_id).delete 
      Business.find(company.business_id).delete 
      CompanyLocation.find(company.company_location_id).delete 
      Company.find(company.company_id).delete 
      ContactCompany.find(company.contact_company_id).delete
      Review.where(:company_id => company.company_id).each do |review|
        review.update_attributes(:company_id => nil)
      end
      Feedback.where(:company_id => company.company_id).each do |feedback|
        feedback.update_attributes(:company_id => nil)
      end
      company.delete
    end
  end
end
