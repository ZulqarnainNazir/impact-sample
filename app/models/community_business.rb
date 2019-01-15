class CommunityBusiness < ActiveRecord::Base
  belongs_to :community, inverse_of: :community_businesses
  belongs_to :business, inverse_of: :community_businesses

  # validates_presence_of :community
  # validates_presence_of :business
  # validates :community, presence: true
  # validates :business, presence: true

  def is_anchor?
    self.anchor == true
  end

  def is_champion?
    self.champion == true
  end

end
