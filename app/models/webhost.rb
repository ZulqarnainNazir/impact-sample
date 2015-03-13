class Webhost < ActiveRecord::Base
  belongs_to :website, touch: true

  validates :name, presence: true, uniqueness: { case_sensitive: true }, format: { with: /\A[\w\.]+\z/ }
end
