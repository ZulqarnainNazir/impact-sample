class ReviewWidget < ActiveRecord::Base
  after_initialize :init

  belongs_to :business

  def init
    self.uuid ||= SecureRandom.uuid
  end
  
  def self.layouts
    {"Default" => "default", "Columns" => "columns", "List View" => "sidebar"}
  end
end
