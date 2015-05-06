class TeamMember < ActiveRecord::Base
  include PlacedImageConcern

  belongs_to :business, touch: true

  has_placed_image :team_member_profile

  def name
    [first_name, last_name].reject(&:blank?).join(' ')
  end

  def small_profile_url
    team_member_profile.try(:attachment_url, :team_member_profile_small)
  end

  def large_profile_url
    team_member_profile.try(:attachment_url, :team_member_profile_large)
  end
end
