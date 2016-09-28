class Pdf < ActiveRecord::Base
  attr_accessor :attachment
  attr_accessor :attachment_file_name
  attr_accessor :attachment_file_size
  attr_accessor :attachment_content_type
  attr_accessor :attachment_updated_at
  belongs_to :user
  belongs_to :business


  validates_attachment_presence :attachment
  has_attached_file :attachment

  validates_with AttachmentSizeValidator, attributes: :attachment, less_than: 20.gigabytes

  validates :business_id, presence: true, unless: :business
  validates :user_id, presence: true, unless: :user
end
