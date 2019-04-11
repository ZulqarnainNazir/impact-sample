module Concerns
  module Communities
    extend ActiveSupport::Concern

    include Concerns::Connections

    # def assign_to_communitities(target_business)
    #
    #   @logs = []
    #   @count = 0
    #
    #   # if first_generation_connections(community, business) || second_generation_connections(community, business) || third_generation_connections(community, business)
    #   if first_gen(target_business)
    #     # business.community = community
    #     @logs << "#{business.name} was added to #{community.label} as a first generation connection."
    #     @count += 1
    #   elsif second_gen(target_business)
    #     # business.community = community
    #     @logs <<  "#{business.name} was added to #{community.label} as a second generation connection."
    #     @count += 1
    #   elsif third_gen(target_business)
    #     # business.community = community
    #     @logs <<  "#{business.name} was added to #{community.label} as a third generation connection."
    #     @count += 1
    #   else
    #     # business.community = ""
    #     @logs <<  "#{business.name} was removed from #{community.label}."
    #     @count += 1
    #   end
    #
    #   @logs
    #
    # end
    #
    # def first_gen(target_business)
    #
    #   ambassadors_businesses = []
    #
    #   Community.all.each do |community|
    #     community.community_businesses.where('anchor=? OR champion=?', true, true).each do |ambassador|
    #       # if ambassador.company_lists.companies.include?(target_business) || ambassador.anchor? || ambassador.champion?
    #       ambassadors_businesses = supporting(Business.find(ambassador.business_id))
    #
    #       if ambassadors_businesses.include?(target_business) || ambassador.anchor? || ambassador.champion?
    #         return true
    #       end
    #     end
    #   end
    #
    #   return false
    #
    # end
    #
    # def second_gen(target_business)
    #
    #   Community.all.each do |community|
    #
    #     community_businesses = []
    #     community.businesses.each do |business|
    #       # if ambassador.company_lists.companies.include?(target_business) || ambassador.anchor? || ambassador.champion?
    #       community_businesses << supporting(Business.find(business.id))
    #     end
    #
    #
    #     if community_businesses.map { |x| community_businesses.count(x)} <= 2
    #       return true
    #     end
    #     end
    #   end
    #
    #   return false
    #
    #
    #   count = 0
    #   community.businesses.each do |business|
    #     if supporting(Business.find(business.id)).include?(target_business)
    #       count += 1
    #     end
    #   end
    #   if count >= 2
    #     return true
    #   end
    #
    #   return false
    #
    #
    # end
    #
    #
    # def third_gen(target_business)
    #
    # end










    #This is probably moved to the rake task to update existing
    def assign_businesses_to_communities

      Business.all.each do |business|
        Community.all.each do |community|

          @logs = []
          @count = 0

          # if first_generation_connections(community, business) || second_generation_connections(community, business) || third_generation_connections(community, business)
          if first_generation_connections(community, business)
            # business.community = community
            @logs << "#{business.name} was added to #{community.label} as a first generation connection."
            @count += 1
          elsif second_generation_connections(community, business)
            # business.community = community
            @logs <<  "#{business.name} was added to #{community.label} as a second generation connection."
            @count += 1
          elsif third_generation_connections(community, business)
            # business.community = community
            @logs <<  "#{business.name} was added to #{community.label} as a third generation connection."
            @count += 1
          else
            # business.community = ""
            @logs <<  "#{business.name} was removed from #{community.label}."
            @count += 1
          end

          @logs
          @count

          # business.save
        end
      end

    end

    # if your an anchor or champion (ambassador), a community has been created by a super admin and you've been added to that community manually and thereofre should always be a part of the community
    # Or if you are supported by an anchor or champion you are part of the community
    def first_generation_connections (community, target_business)

        community.community_businesses.where('anchor=? OR champion=?', true, true).each do |ambassador|
          # if ambassador.company_lists.companies.include?(target_business) || ambassador.anchor? || ambassador.champion?
          supporting = supporting(Business.find(ambassador.business_id))

          if supporting.include?(target_business.company) || ambassador.anchor? || ambassador.champion?

            return true
          end
        end

        return false

    end

    # if 2 or more community members support you, you are part of the community
    def second_generation_connections(community, target_business)

        count = 0
        community.businesses.each do |business|
          if supporting(Business.find(business.id)).include?(target_business.company)
            count += 1
          end
        end
        if count >= 2
          return true
        else
          return false
        end
    end

    # if a business supports 3 or more existing community members, they are part of the community
    def third_generation_connections(community, target_business)

        count = 0
        community.businesses.each do |business|
          if supporting(Business.find(target_business.id)).include?(business.company)
            count += 1
          end
        end
        if count >= 3
          return true
        else
          return false
        end

    end

  end
end
