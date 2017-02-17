class Businesses::Crm::ImportsController < Businesses::BaseController
  def index
  end
  
  def review
    file_data = params[:import_file]
    if file_data.respond_to?(:read)
        uploaded_io = file_data.read
    elsif file_data.respond_to?(:path)
        uploaded_io = File.read(file_data.path)
    else
        logger.error "Bad file_data: #{file_data.class.name}: #{file_data.inspect}"
    end
    @filename = "#{SecureRandom.uuid}.csv"
    File.open(Rails.root.join('tmp', @filename), 'wb') do |file|
        file.write(uploaded_io)
    end
    if params[:import_type] == "contacts"
      review_contacts
    elsif params[:import_type] == "companies"
      review_companies
    end
  end

  def review_contacts
    @contacts = ContactSchema.conform(CSV.read(Rails.root.join("tmp", @filename), skip_blanks: true).reject { |row| row.all?(&:nil?) })
    if @contacts.first.first_name == "First Name"
      @contacts = @contacts.drop(1)
    end
    @skip = check_contact_validation @contacts
    @duplicates = Contact.get_duplicates(@business, @contacts, @skip[:skip_indexes])
    render "review_contacts"
  end

  def review_companies
    @companies = CompanySchema.conform(CSV.read(Rails.root.join("tmp", @filename), skip_blanks: true).reject { |row| row.all?(&:nil?) })
    if @companies.first.name == "Company Name"
      @companies = @companies.drop(1)
    end
    @skip = check_company_validation @companies
    @duplicates = Company.get_duplicates(@business, @companies, @skip[:skip_indexes])
    render "review_companies"
  end

  def review_duplicates
    if params[:import_type] == "contacts"
      review_contact_duplicates
    elsif params[:import_type] == "companies"
      review_company_duplicates
    end
  end

  def review_contact_duplicates
    @filename = params[:filename]
    @contacts = ContactSchema.conform(CSV.read(Rails.root.join("tmp", @filename), skip_blanks: true).reject { |row| row.all?(&:nil?) })
    if @contacts.first.first_name == "First Name"
      @contacts = @contacts.drop(1)
    end
    @duplicates = Contact.get_duplicates(@business, @contacts, params[:skip_indexes].split(','))
    render "review_contact_duplicates"
  end

  def review_company_duplicates
    @filename = params[:filename]
    @companies = CompanySchema.conform(CSV.read(Rails.root.join("tmp", @filename), skip_blanks: true).reject { |row| row.all?(&:nil?) })
    if @companies.first.name == "Company Name"
      @companies = @companies.drop(1)
    end
    @duplicates = Company.get_duplicates(@business, @companies, params[:skip_indexes].split(','))
    render "review_company_duplicates"
  end

  def process_csv
    if params[:import_type] == "contacts"
      process_csv_contacts
    elsif params[:import_type] == "companies"
      process_csv_companies
    end
  end

  def process_csv_contacts
    @filename = params[:filename]
    @contacts = ContactSchema.conform(CSV.read(Rails.root.join("tmp", @filename), skip_blanks: true).reject { |row| row.all?(&:nil?) })
    if @contacts.first.first_name == "First Name"
      @contacts = @contacts.drop(1)
    end
    contact_business = {:business_id => @business.id}
    @contacts.each_with_index do |contact, i|
      if params[:skip_indexes].split(',').include?(i.to_s)
        next
      end
      contact.attributes.merge!(contact_business)
      if !params[:merge].blank? and !params[:merge][i.to_s].blank? and params[:merge][i.to_s] == "yes"
        Contact.find(params[:merge_id][i.to_s].to_i).update_attributes! contact.attributes.reject{|k,v| v.blank?}
      elsif !params[:merge].blank? and !params[:merge][i.to_s].blank? and params[:merge][i.to_s] == "skip" 
        next
      else
        Contact.create! contact.attributes
      end
    end
    File.delete(Rails.root.join("tmp", @filename))
    redirect_to [@business, :crm_contacts], :notice => "Import was successful"
  end

  def process_csv_companies
    @filename = params[:filename]
    @companies = CompanySchema.conform(CSV.read(Rails.root.join("tmp", @filename), skip_blanks: true).reject { |row| row.all?(&:nil?) })
    if @companies.first.name == "Company Name"
      @companies = @companies.drop(1)
    end
    @companies.each_with_index do |company, i|
      if params[:skip_indexes].split(',').include?(i.to_s)
        next
      end
      company.attributes[:company_location_attributes] = Hash.new
      company.attributes.each do |key, value|
        if key.to_s.include? "location_" and !key.to_s.include? "location_attributes"
          company.attributes[:company_location_attributes][key[9..key.length].to_sym] = value
          company.attributes.delete(key.to_sym)
        end
      end
      if !params[:merge].blank? and !params[:merge][i.to_s].blank? and params[:merge][i.to_s] == "yes" 
        if !params[:merge_class][i.to_s].blank? and params[:merge_class][i.to_s] == "business"
          company_db = Company.new(:user_business_id => @business.id, :company_business_id => params[:merge_id][i.to_s].to_i, :name => company.name,
                                   :company_location_attributes => {:name => company.name})
          company_db.save
          company_db.update_attributes! company.attributes
          company.attributes[:location_attributes] = company.attributes.delete :company_location_attributes
          company_db.business.update_attributes_only_if_blank company.attributes.reject{|k,v| v.blank?}
        else
          Company.find(params[:merge_id][i.to_s].to_i).update_attributes! company.attributes.reject{|k,v| v.blank?}
        end
      elsif !params[:merge].blank? and !params[:merge][i.to_s].blank? and params[:merge][i.to_s] == "skip" 
        next
      else
        company_db = Company.create_with_associations company.attributes, @business
        company_db.update_attributes! company.attributes
        company.attributes[:location_attributes] = company.attributes.delete :company_location_attributes
        company_db.business.update_attributes_only_if_blank company.attributes
      end
    end
    File.delete(Rails.root.join("tmp", @filename))
    redirect_to [@business, :crm_companies], :notice => "Import was successful"
  end

  def download_contact_template
    @file = "#{::Rails.root}/app/assets/documents/Contact-Import-Template.csv"
    send_file @file, :type => 'text/csv'
  end

  def download_company_template
    @file = "#{::Rails.root}/app/assets/documents/Company-Import-Template.csv"
    send_file @file, :type => 'text/csv'
  end

  private

  def check_contact_validation contacts
    skip_indexes = []
    skip_contacts = [] 
    keep_contacts = []
    contacts.each_with_index do |contact, i|
      if (contact.first_name.blank? and contact.last_name.blank? and contact.email.blank?) or (!contact.state.blank? and contact.state.length > 2)
        skip_indexes << i
        skip_contacts << contact 
      else
        keep_contacts << contact
      end
    end
    {:skip_indexes => skip_indexes, :skip_contacts => skip_contacts, :keep_contacts => keep_contacts}
  end

  def check_company_validation companies
    skip_indexes = []
    skip_companies = [] 
    keep_companies = []
    companies.each_with_index do |company, i|
      if company.name.blank? or (!company.location_state.blank? and company.location_state.length > 2)
        skip_indexes << i
        skip_companies << company 
      else
        keep_companies << company
      end
    end
    {:skip_indexes => skip_indexes, :skip_companies => skip_companies, :keep_companies => keep_companies}
  end
end
