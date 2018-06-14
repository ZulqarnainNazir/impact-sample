class CompanyListCompany < ActiveRecord::Base
  #default_scope { joins(:company).order('companies.name DESC') }
  before_save :set_company_list
  belongs_to :company_list
  belongs_to :company_list_categories
  belongs_to :company

  def set_company_list
    if self.company_list_category_id
      self.company_list_id = CompanyListCategory.find(self.company_list_category_id).company_list_id
    end
  end
end
