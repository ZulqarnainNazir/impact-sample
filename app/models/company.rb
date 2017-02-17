class Company < ActiveRecord::Base
  
  belongs_to :business, :class_name => "Business", :foreign_key => "company_business_id"
  has_one :company_location
  has_many :contact_companies, :dependent => :destroy
  has_many :contacts, :through => :contact_companies
  has_many :crm_notes, :dependent => :destroy
  has_many :reviews

  accepts_nested_attributes_for :business, update_only: true
  accepts_nested_attributes_for :company_location, update_only: true
  accepts_nested_attributes_for :crm_notes, reject_if: :all_blank

  validates :company_location, presence: true

  def self.select_collection(user_business_id, contact_id = nil) 
    if contact_id.nil?
      select("companies.id, businesses.name").joins(:business).where(:user_business_id => user_business_id) 
    else
      select("companies.id, businesses.name").joins(:business).joins(:contact_companies).where(:user_business_id => user_business_id, :"contact_companies.contact_id" => contact_id) 
    end
  end
  def self.create_with_associations(params, user_business)
    if params[:website_url].nil?
      business = Business.new(:name => params[:name], :in_impact => false)
    else
      business = Business.new(:name => params[:name], :website_url => params[:website_url], :in_impact => false)
    end
    business.save(:validate => false)
    Location.new(:business_id => business.id, :name => params[:name]).save(:validate => false)
    if params[:website_url].nil?
      company = Company.new(:user_business_id => user_business.id, :company_business_id => business.id, :name => params[:name])
    else
      company = Company.new(:user_business_id => user_business.id, :company_business_id => business.id, :name => params[:name], :website_url => params[:website_url])
    end
    company.save(:validate => false)
    CompanyLocation.create(:company_id => company.id, :name => params[:name])
    company
  end

  def self.get_duplicates business, new_companies, skip_indexes
    duplicates = {}
    new_companies.each_with_index do |new_company, i|
      if skip_indexes.include?(i.to_s)
        next
      end
      business_dup = 
      dup = self.get_duplicate business, new_company
      if dup != false
        duplicates[i] = dup
      end
    end 
    if !duplicates.blank?
      duplicates
    end
  end

  def self.get_duplicate business, new_company
    matches = []
    if(!new_company[:location_phone_number].blank?)
      matches += where(:user_business_id => business.id).joins(:company_location).where("regexp_replace(company_locations.phone_number, '[^0-9]+', '', 'g')=regexp_replace(?, '[^0-9]+', '', 'g')", new_company[:location_phone_number])
    end
    %w[name website_url facebook_id twitter_id instagram_id].each do |column|
      if(!new_company[column.to_sym].blank?)
        matches += where(:user_business_id => business.id).where("LOWER(#{column})=LOWER(?)", new_company[column.to_sym])
      end
    end
    %w[location_email].each do |column|
      column_n = column[9..column.length]
      if(!new_company[column.to_sym].blank?)
        matches += where(:user_business_id => business.id).joins(:company_location).where("LOWER(company_locations.#{column_n})=LOWER(?)", new_company[column.to_sym])
      end
    end
    if(!new_company[:location_street1].blank?)
      matches += where(:user_business_id => business.id).joins(:company_location).where("LOWER(company_locations.street1)=LOWER(?) AND LOWER(company_locations.city)=LOWER(?) AND LOWER(company_locations.state)=LOWER(?) AND LOWER(company_locations.zip_code)=LOWER(?)", new_company[:location_street1], new_company[:location_city], new_company[:location_state], new_company[:location_zip_code])
    end
    business_match = Business.joins("INNER JOIN companies ON businesses.id=companies.company_business_id").where("companies.user_business_id = ?", business.id).get_duplicate new_company
    if matches.blank?
      business_only_match = Business.get_duplicate new_company
      if business_only_match.blank?
        return false
      else
        return Business.find(business_only_match)
      end
    end
    counts = matches.each_with_object(Hash.new(0)) { |o, h| h[o[:id]] += 1 }
    counts.each do |k, v|
      if find(k).business.id = business_match
        counts[k] += 1
      end
    end
    best_match = counts.sort_by {|k,v| v}.reverse[0][0].to_i
    find(best_match)
  end
end
