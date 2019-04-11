module Concerns
  module Connections
    extend ActiveSupport::Concern

    #Supporter (Supported By/Follower/Followed By)
    ######################################################

    def supporters(business)
      # Returns object of all unique companies Supporting this business

      companies = []
      business.listed_by_business.each {|company| companies << company.company}

      companies.uniq # Note this is still not completely unique as it counts when part of multiple networks

    end

    #Supporting (Following)
    ######################################################

    def supporting(business)
      # Returns object of all unqiue companies this business is Supporting

      companies = []
      business.company_lists.each {|list| companies = companies.concat(list.companies)}

      companies.uniq

    end

  end
end
