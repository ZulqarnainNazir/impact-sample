class Business < ActiveRecord::Base
  include PlacedImageConcern

  has_many :images

  with_options dependent: :destroy do
    has_many :authorizations
    has_many :categorizations
    has_many :contact_messages
    has_many :team_members
    has_many :users
    has_one :location
    has_one :website
  end

  has_many :authorized_owners, -> { owner }, class_name: Authorization.name
  has_many :categories, through: :categorizations
  has_many :owners, through: :authorized_owners, source: :user

  has_placed_image :logo

  accepts_nested_attributes_for :location
  accepts_nested_attributes_for :website

  enum kind: {
    traditional_business: 0,
    group_or_cause: 1,
  }

  validates :name, presence: true

  with_options unless: -> { validation_context.to_sym == :onboard_website } do
    validates :category_ids, presence: true
  end

  with_options on: :onboard_website do
    validates :location, presence: true
    validates :website, presence: true
  end

  before_validation on: :onboard_website do
    self.location_attributes = {
      name: name,
    }

    self.website_attributes = {
      subdomain: Website.available_subdomain(name),
      header_block_attributes: {
        theme: 'inline',
        style: 'dark',
      },
      footer_block_attributes: {
        theme: 'simple',
      },
    }
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
