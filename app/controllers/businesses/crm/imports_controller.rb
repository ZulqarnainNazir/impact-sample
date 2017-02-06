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
    @contacts = ContactSchema.conform(CSV.read(Rails.root.join("tmp", @filename), skip_blanks: true).reject { |row| row.all?(&:nil?) })
    if @contacts.first.first_name == "First Name"
      @contacts = @contacts.drop(1)
    end
    @skip = check_validation @contacts
    @duplicates = Contact.get_duplicates(@business, @contacts, @skip[:skip_indexes])
  end

  def review_duplicates
    @filename = params[:filename]
    @contacts = ContactSchema.conform(CSV.read(Rails.root.join("tmp", @filename), skip_blanks: true).reject { |row| row.all?(&:nil?) })
    if @contacts.first.first_name == "First Name"
      @contacts = @contacts.drop(1)
    end
    @duplicates = Contact.get_duplicates(@business, @contacts, params[:skip_indexes].split(','))
  end

  def process_csv
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
        Contact.find(params[:merge_id][i.to_s].to_i).update_attributes! contact.attributes
      elsif !params[:merge].blank? and !params[:merge][i.to_s].blank? and params[:merge][i.to_s] == "skip" 
        next
      else
        Contact.create! contact.attributes
      end
    end
    File.delete(Rails.root.join("tmp", @filename))
    redirect_to [@business, :crm_contacts], :notice => "Import was successful"
  end

  def download_contact_template
    @file = "#{::Rails.root}/app/assets/documents/Contact-Import-Template.csv"
    send_file @file, :type => 'text/csv'
  end

  private

  def check_validation contacts
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
end
