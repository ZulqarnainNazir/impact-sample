class CompanyImportJob < ApplicationJob
  queue_as :default

  def perform(key, business, params)
    file_name = Rails.root.join('tmp', File.basename(key))

    S3Service.download(key, file_name)

    companies = CompanySchema.conform(CSV.read(file_name, skip_blanks: true).reject { |row| row.all?(&:nil?) })

    if companies.first&.name == "Company Name"
      companies = companies.drop(1)
    end
    companies.each_with_index do |company, i|
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
          company_db = Company.new(user_business_id: business.id, :company_business_id => params[:merge_id][i.to_s].to_i, name: company.name,
                                   company_location_attributes: { name: company.name })
          company_db.save
          company_db.business.attributes.each do |key,value|
            if company.attributes[key] == value
              company.attributes.delete key.to_sym
            end
          end
          location_attributes = company.attributes[:company_location_attributes].clone
          category_ids = Category.where("name in (?)", company.attributes.delete(:category_ids)).ids
          company_db.business.location.attributes.each do |key,value|
            if company.attributes[:company_location_attributes][key] == value
              company.attributes[:company_location_attributes].delete key
            end
          end
          company_db.business.location.attributes.each do |key,value|
            if value.blank? and key != "email" and !company_db.business.in_impact == true
              company.attributes[:company_location_attributes].delete key.to_sym
            end
          end
          company_db.update_attributes! company.attributes
          company.attributes.delete :company_location_attributes
          #No importing data into company if its a new business. All data should go to business
          #company_db.update_attributes! company.attributes
          company.attributes[:location_attributes] = location_attributes
          company.attributes[:category_ids] = category_ids
          company_db.business.update_attributes_only_if_blank company.attributes
        else
          company_db = Company.find(params[:merge_id][i.to_s].to_i)
          company_db.business.attributes.each do |key,value|
            if company.attributes[key.to_sym] == value
              company.attributes.delete key.to_sym
            end
          end
          company_db.business.location.attributes.each do |key,value|
            if company.attributes[:company_location_attributes][key.to_sym] == value
              company.attributes[:company_location_attributes].delete key.to_sym
            end
          end
          cat_ids = company.attributes.delete(:category_ids)
          company_db.business.update_attributes_only_if_blank(location_attributes: {}, category_ids: cat_ids)
          company_db.update_attributes! company.attributes
        end
      elsif !params[:merge].blank? and !params[:merge][i.to_s].blank? and params[:merge][i.to_s] == "skip"
        next
      else
        company_db = Company.create_with_associations company.attributes, business
        #No importing data into company if its a new business. All data should go to business
        #company_db.update_attributes! company.attributes
        company.attributes[:location_attributes] = company.attributes.delete :company_location_attributes
        company.attributes[:category_ids] = Category.where("name in (?)", company.attributes[:category_ids]).ids
        company_db.business.update_attributes_only_if_blank company.attributes, true
      end
    end


    File.delete(file_name) if File.exist?(file_name)
  end
end
