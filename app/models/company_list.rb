class CompanyList < ActiveRecord::Base
  belongs_to :business

  has_many :company_list_companies, :dependent => :destroy

  has_many :company_list_categories, :dependent => :destroy

  has_many :companies, :through => :company_list_companies

  has_many :directory_widgets

  accepts_nested_attributes_for :company_list_categories, allow_destroy: true, reject_if: proc { |a|
    a['_destroy'] == '1' || (
      a['label'].blank? &&
      a['company_ids'].blank?
    )
  }

  def self.select_collection(business_id)
    select("company_lists.id, company_lists.name").where(:business_id => business_id)
  end

  validates :name, presence: true

end
