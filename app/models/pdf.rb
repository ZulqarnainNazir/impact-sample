class Pdf < ActiveRecord::Base
  belongs_to :user
  belongs_to :business
  has_attached_file :attachment
  validates_with AttachmentPresenceValidator, attributes: :attachment
  validates_with AttachmentSizeValidator, attributes: :attachment, less_than: 20.gigabytes
  validates_with AttachmentContentTypeValidator, attributes: :attachment, content_type: 'application/pdf'

  validates :business_id, presence: true, unless: :business
  validates :user_id, presence: true, unless: :user
end
