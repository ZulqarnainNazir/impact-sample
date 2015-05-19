class Category < ActiveRecord::Base
  has_many :categorizations, dependent: :destroy
  has_many :businesses, through: :categorizations

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :pathname, presence: true, format: { with: /\A[\w\-]+\z/ }, uniqueness: { case_sensitive: false }

  before_validation do
    self.name = self.name.titleize if name.present?
    self.pathname = name.parameterize if pathname.blank? && name.present?
  end

  def self.alphabetical
    order(pathname: :asc)
  end
end
