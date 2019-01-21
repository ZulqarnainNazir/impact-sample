class CommunityBusiness < ActiveRecord::Base

  belongs_to :community
  belongs_to :business

  validates_presence_of :community
  validates_presence_of :business
  # # validates :business_id, uniqueness: { scope: [:community_id] }

  # def is_anchor?
  #   self.anchor == true
  # end
  #
  # def is_champion?
  #   self.champion == true
  # end

end
