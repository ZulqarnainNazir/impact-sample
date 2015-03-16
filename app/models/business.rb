class Business < ActiveRecord::Base
  include PlacedImageConcern

  has_many :authorizations, dependent: :destroy
  has_many :users, through: :authorizations

  has_many :authorized_owners, -> { owner }, class_name: Authorization.name
  has_many :owners, through: :authorized_owners, source: :user

  has_many :categorizations, dependent: :destroy
  has_many :categories, through: :categorizations

  has_many :images
  has_many :team_members, dependent: :destroy

  has_one :location
  has_one :website

  has_placed_image :logo

  validates :category_ids, presence: true
  validates :name, presence: true

  with_options on: :location do
    validates :location, presence: true
  end

  with_options on: :website do
    validates :website, presence: true
  end

  before_validation do
    authorizations.each     { |r| r.business = self unless r.business }
    authorized_owners.each  { |r| r.business = self unless r.business }
    categorizations.each    { |r| r.business = self unless r.business }
  end

  def self.alphabetical
    order('LOWER(name) ASC')
  end
end
