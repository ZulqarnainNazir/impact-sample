class ContactImportJob < ApplicationJob
  queue_as :default

  def perform(key, business, params)
    file_name = Rails.root.join('tmp', File.basename(key))

    S3Service.download(key, file_name)

    rows = CSV.read(file_name, skip_blanks: true)
    contacts = ContactSchema.conform(rows.reject { |row| row.all?(&:nil?) })

    if contacts.first.first_name == 'First Name'
      contacts = contacts.drop(1)
    end

    contacts.each_with_index do |contact, i|
      if params[:skip_indexes].split(',').include?(i.to_s)
        next
      end
      contact.attributes.merge!(business_id: business.id)
      if !params[:merge].blank? and !params[:merge][i.to_s].blank? and params[:merge][i.to_s] == 'yes'
        Contact.find(params[:merge_id][i.to_s].to_i).update_attributes! contact.attributes.reject{|k,v| v.blank?}
      elsif !params[:merge].blank? and !params[:merge][i.to_s].blank? and params[:merge][i.to_s] == 'skip'
        next
      else
        Contact.create! contact.attributes
      end
    end

    File.delete(file_name) if File.exist?(file_name)
  end
end
