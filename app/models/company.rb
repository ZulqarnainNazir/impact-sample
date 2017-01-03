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
end
