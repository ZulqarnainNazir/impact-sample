module Concerns
  module Communities
    extend ActiveSupport::Concern

    include Concerns::Connections

    def assign_businesses_to_communities

      Business.all.each do |business|
        Community.all.each do |community|

          # if first_generation_connections(community, business) || second_generation_connections(community, business) || third_generation_connections(community, business)
          if first_generation_connections(community, business)
            # business.community = community
            puts "#{business.name} was added to #{community.label} as a first generation connection."
          elsif second_generation_connections(community, business)
            # business.community = community
            puts "#{business.name} was added to #{community.label} as a second generation connection."
          elsif third_generation_connections(community, business)
            # business.community = community
            puts "#{business.name} was added to #{community.label} as a third generation connection."
          else
            # business.community = ""
            puts "#{business.name} was removed from #{community.label}."
          end

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
          byebug

          if supporting(Business.find(ambassador.business_id)).include?(target_business.id) || ambassador.anchor? || ambassador.champion?

            return true
          else
            return false
          end
        end

    end

    # if 2 or more community members support you, you are part of the community
    def second_generation_connections(community, target_business)

        count = 0
        community.businesses.each do |business|
          if supporting(Business.find(business.id)).include?(target_business.id)
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
          if supporting(Business.find(target_business.id)).include?(business.id)
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
