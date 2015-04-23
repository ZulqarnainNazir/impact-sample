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
    { gallery_image: '200x200#' }
  end

  def logo
    { small: 'x40', medium: 'x60', large: 'x78' }
  end

  def project_image
    { project_image: 'x300' }
  end

  def team_member_profile
    { small: 'x165', large: 'x360' }
  end
end
