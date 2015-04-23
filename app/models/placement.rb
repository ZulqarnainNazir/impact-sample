class Placement < ActiveRecord::Base
  belongs_to :placer, polymorphic: true
  belongs_to :image

  accepts_nested_attributes_for :image, reject_if: :all_blank

  validates :placer, presence: true
  validates :image, presence: true

  after_save do
    ImageAttachmentReprocessJob.perform_later(image) if image && image_id_changed?
  end

  def styles
    context? && respond_to?(context) ? send(context) : {}
  end

  def gallery_image
    {
      gallery_image_small: '200x200#',
      gallery_image_large: '800x800',
    }
  end

  def logo
    {
      logo_small: 'x40',
      logo_medium: 'x60',
      logo_large: 'x78',
      logo_square: '200x200#',
    }
  end

  def team_member_profile
    {
      team_member_profile_small: 'x165',
      team_member_profile_large: 'x360',
    }
  end
end
