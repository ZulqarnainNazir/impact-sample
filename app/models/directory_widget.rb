class DirectoryWidget < ActiveRecord::Base
  after_initialize :init
  belongs_to :business
  belongs_to :company_list

  validates :name, presence: true
  validates :company_list, presence: true

  def init
    self.uuid ||= SecureRandom.uuid
  end
end
