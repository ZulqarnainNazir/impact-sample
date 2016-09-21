class Pdf < ActiveRecord::Base
  belongs_to :user
  belongs_to :business
<<<<<<< b0c1514e4796a757b3833f7f930569800e7c5d21
<<<<<<< 65521e64327587f369d95bc14f61b098a0b44919
=======
>>>>>>> errors, validations, migrations, form, and index page for pdfs
  attr_accessor :attachment
  has_attached_file :attachment

  validates_attachment_file_name :attachment, :matches => [/png\Z/, /jpe?g\Z/, /pdf\Z/]

  validates :attachment, attachment_presence: true
  validates_with AttachmentPresenceValidator, attributes: :attachment
  validates_with AttachmentSizeValidator, attributes: :attachment, less_than: 20.gigabytes

<<<<<<< b0c1514e4796a757b3833f7f930569800e7c5d21
=======
>>>>>>> skeleton for pdfs - navigation, controller, model
=======
>>>>>>> errors, validations, migrations, form, and index page for pdfs

  validates :business_id, presence: true, unless: :business
  validates :user_id, presence: true, unless: :user
end
