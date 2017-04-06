class CompanyListCategory < ActiveRecord::Base
  default_scope { order('position') }
  belongs_to :company_list
  has_many :company_list_companies, :dependent => :destroy
  has_many :companies, :through => :company_list_companies
  accepts_nested_attributes_for :company_list_companies, allow_destroy: true

end
