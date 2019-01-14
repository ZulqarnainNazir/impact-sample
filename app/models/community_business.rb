class CommunityBusiness < ActiveRecord::Base
  belongs_to :community
  belongs_to :business

  def is_anchor?
    self.anchor == true
  end

  def is_champion?
    self.champion == true
  end

end
