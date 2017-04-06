class DirectoryWidget < ActiveRecord::Base
  after_initialize :init
  belongs_to :business
  belongs_to :company_list

  def init
    self.uuid ||= SecureRandom.uuid
  end



end
