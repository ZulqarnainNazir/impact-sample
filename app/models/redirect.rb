class Redirect < ActiveRecord::Base
  belongs_to :website

  validates :website, presence: true
  validates :from_path, format: { with: /\A\// }, uniqueness: { case_sensitive: false }, allow_blank: true
  validates :to_path, format: { with: /\A\// }, allow_blank: true

  before_validation do
    self.from_path = '/' + self.from_path if from_path? && from_path[0] != '/'
    self.to_path = '/' + self.to_path if to_path? && to_path[0] != '/'
  end
end
