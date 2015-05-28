class TeamMember < ActiveRecord::Base
  include PlacedImageConcern

  belongs_to :business, touch: true

  has_placed_image :team_member_profile

  def self.default_scope
    order(position: :asc)
  end

  def name
    [first_name, last_name].reject(&:blank?).join(' ')
  end

  def profile_url
    team_member_profile.try(:attachment_url, :small)
  end
end
