class Pdf < ActiveRecord::Base
  belongs_to :user
  belongs_to :business
  attr_accessor :attachment
  has_attached_file :attachment

  validates_attachment_file_name :attachment, :matches => [/png\Z/, /jpe?g\Z/, /pdf\Z/]

  validates :attachment, attachment_presence: true
  validates_with AttachmentPresenceValidator, attributes: :attachment
  validates_with AttachmentSizeValidator, attributes: :attachment, less_than: 20.gigabytes


  validates :business_id, presence: true, unless: :business
  validates :user_id, presence: true, unless: :user
end
