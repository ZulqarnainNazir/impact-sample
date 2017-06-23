require 'sidekiq/api'

class Businesses::Crm::ImportsController < Businesses::BaseController
  def index
  end

  def review
    @filename = params[:filename]
    ordering = params[:order]
    tmp_file_path = Rails.root.join("tmp", @filename)
    csv = CSV.read(tmp_file_path, skip_blanks: true)

    if params[:import_type] == "contacts"
      File.open(tmp_file_path, 'w') do |file|
        file.puts ContactSchema.remap(csv, ordering)
      end
      review_contacts
    elsif params[:import_type] == "companies"
      File.open(tmp_file_path, 'w') do |file|
        file.puts CompanySchema.remap(csv, ordering)
      end
      review_companies
    end
  end

  def match_columns
    begin
      write_import_file
      csv = CSV.read(Rails.root.join("tmp", @filename), skip_blanks: true)
    rescue => error
      redirect_to [@business, :crm_imports], notice: "Invalid CSV file, it appears the file you uploaded has some non-standard characters. Please remove these characters and upload again."
      return
    end

    if params[:import_type] == "contacts"
      @csv_columns = csv.first.map.with_index { |item, idx| { key: item, index: idx, sample: (csv.second[idx] if csv.second) } }
      @columns = ContactSchema.to_hash
    elsif params[:import_type] == "companies"
      @csv_columns = csv.first.map.with_index { |item, idx| { key: item, index: idx, sample: (csv.second[idx] if csv.second) } }
      @columns = CompanySchema.to_hash
    end
  end

  def review_contacts
    begin
      @contacts = ContactSchema.conform(CSV.read(Rails.root.join("tmp", @filename), skip_blanks: true).reject { |row| row.all?(&:nil?) })
    rescue => error
      redirect_to [@business, :crm_imports], :notice => "Invalid CSV file, it appears the file you uploaded has some non-standard characters. Please remove these characters and upload again."
      return
    end
    if @contacts.first.first_name == "Company Name" || @contacts.first.attributes.length != 11
      redirect_to [@business, :crm_imports], :notice => "Invalid CSV Import for contacts. Did you intend to import this as companies?"
      return
    end
    if @contacts.first.first_name&.downcase == "first name"
      @contacts = @contacts.drop(1)
    end
    @skip = check_contact_validation @contacts
    @duplicates = Contact.get_duplicates(@business, @contacts, @skip[:skip_indexes])
    render "review_contacts"
  end

  def review_companies
    begin
      @companies = CompanySchema.conform(CSV.read(Rails.root.join("tmp", @filename), skip_blanks: true).reject { |row| row.all?(&:nil?) })
    rescue => error
      redirect_to [@business, :crm_imports], :notice => "Invalid CSV file, it appears the file you uploaded has some non-standard characters. Please remove these characters and upload again."
      return
    end
    if @companies.first.name == "First Name" || @companies.first.attributes.length != 14
      redirect_to [@business, :crm_imports], :notice => "Invalid CSV Import for companies. Did you intend to import this as contacts?"
      return
    end
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
    if @contacts.first.first_name&.downcase == "first name"
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
    upload = S3Service.upload(Rails.root.join('tmp', params[:filename]))

    job = if params[:import_type] == "contacts"
      ContactImportJob.perform_later(upload.key, @business, params)
    elsif params[:import_type] == "companies"
      CompanyImportJob.perform_later(upload.key, @business, params)
    end

    polling_path = import_status_check_business_crm_imports_path(
      @business.id, job.job_id, import_type: params[:import_type]
    )

    render json: { polling_path: polling_path }
  end

  def import_status_check
    if params[:import_type] == "contacts"
      job_class = ContactImportJob
      path = business_crm_contacts_path(@business)
    elsif params[:import_type] == "companies"
      job_class = CompanyImportJob
      path = business_crm_companies_path(@business)
    end

    if job_running?(job_class, params[:job_id])
      render json: { status: 'Pending', redirect_path: path }
    else
      render json: { status: 'Executed', redirect_path: path }
    end
  end

  def download_contact_template
    @file = "#{::Rails.root}/app/assets/documents/Contact-Import-Template.csv"
    send_file @file, :type => 'text/csv; charset=ascii'
  end

  def download_company_template
    @file = "#{::Rails.root}/app/assets/documents/Company-Import-Template.csv"
    send_file @file, :type => 'text/csv; charset=ascii'
  end

  private

  def job_running?(job_class, job_id)
    Sidekiq::Workers.new.find do |process_id, thread_id, work|
      args = work.dig('payload', 'args').first
      args.dig('job_class') == job_class.to_s && args.dig('job_id') == job_id
    end.present?
  end

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

  def write_import_file
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
  end
end
