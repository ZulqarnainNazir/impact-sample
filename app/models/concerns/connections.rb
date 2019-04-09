module Concerns
  module Connections
    extend ActiveSupport::Concern

    def supporters(business)

      business.listed_by_business

    end

    # Get new supporters since last sign in
    def recent_supporters(business)

      last_sign_in_at = current_user.last_sign_in_at
      supporters(business).select { |supporter| last_sign_in_at - supporter.created_at <= 0 }

    end

    def supporting(business)

      companies = []
      business.company_lists.each {|list| companies = companies.concat(list.companies)}

      companies = companies.uniq
      # companies = companies.pluck(:user_business_id).compact
      return companies

    end

    # Get new supporting since last sign in
    def recent_supporting(business)
      last_sign_in_at = current_user.last_sign_in_at
      supporting(business).uniq.select {|supporting| last_sign_in_at - supporting.created_at <= 0}
    end

  end
end
