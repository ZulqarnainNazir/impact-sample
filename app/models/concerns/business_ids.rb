module Concerns
  module BusinessIds
    extend ActiveSupport::Concern

    def get_business_ids
      CompanyList.where(id: company_list_ids).includes(:companies).pluck('companies.company_business_id')
    end
  end
end
