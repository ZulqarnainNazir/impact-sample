class Webpage < ActiveRecord::Base
  store_accessor :settings, :external_line_id, :sidebar_position

  belongs_to :website

  has_many :groups, dependent: :destroy
  has_many :linked_blocks, as: :link, class_name: Block.name
  has_many :nav_links

  with_options allow_destroy: true, reject_if: :all_blank do
    accepts_nested_attributes_for :groups
  end

  validates :pathname, uniqueness: { scope: :website, case_sensitive: false }
  validates :pathname, absence: true, if: -> { type == 'HomePage' }
  validates :pathname, presence: true, format: { with: /\A\w+[\w\-\/]*\w+\z/ }, unless: -> { type == 'HomePage' }
  validates :title, presence: true
  validates :type, presence: true, exclusion: { in: %w[Webpage] }

  before_validation do
    self.name = title if !name? && title?
    self.pathname = title.parameterize if !pathname? && title? && type != 'HomePage'
  end

  def self.custom
    where(type: 'CustomPage')
  end
end
