class Business < ActiveRecord::Base
  include PlacedImageConcern

  has_many :images

  with_options dependent: :destroy do
    has_many :authorizations
    has_many :before_afters
    has_many :categorizations
    has_many :contact_messages
    has_many :galleries
    has_many :lines
    has_many :offers
    has_many :posts
    has_many :quick_posts
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

  accepts_nested_attributes_for :lines, allow_destroy: true, reject_if: proc { |a|
    a['_destroy'] == '1' || (
      a['title'].blank? &&
      a['description'].blank? &&
      a['line_images_attributes'].kind_of?(Hash) && a['line_images_attributes'].all? { |_, b|
        b['_destroy'] == '1' || (
          b['line_image_placement_attributes'].kind_of?(Hash) &&
          b['line_image_placement_attributes'].select { |k,_| !%w[image_business image_user].include?(k) }.values.all?(&:blank?)
        )
      }
    )
  }

  enum kind: {
    traditional_business: 0,
    group_or_cause: 1,
  }

  validates :name, presence: true

  with_options unless: -> { validation_context.to_s.match(/\Aonboard_website/) || validation_context.to_sym == :related_associations } do
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

  def feed_items_count
    before_afters.count + galleries.count + offers.count + posts.count
  end

  def website_url=(value)
    if value.to_s.match(/\Ahttp/)
      super(value.to_s)
    else
      super("http://#{value}")
    end
  end
end
