class Webpage < ActiveRecord::Base
  include PlacedImageConcern

  store_accessor :settings, :external_line_id, :sidebar_position, :page_head_injection

  belongs_to :website

  has_many :groups, dependent: :destroy
  has_many :linked_blocks, as: :link, class_name: Block.name
  has_many :nav_links, dependent: :destroy

  has_placed_image :main_image

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

  def main_image
    super.try(:attachment_url) ||
      Block.where(type: 'HeroBlock', frame_type: 'Group', frame_id: group_ids).first.try(:block_background).try(:attachment_url) ||
      Block.where(type: 'HeroBlock', frame_type: 'Group', frame_id: group_ids).first.try(:block_image).try(:attachment_url) ||
      Block.where(type: 'ContentBlock', frame_type: 'Group', frame_id: group_ids).first.try(:block_image).try(:attachment_url)
  end

  def sidebar_position
    super == 'left' ? 'left' : 'right'
  end

  def sidebar_reverse_position
    sidebar_position == 'left' ? 'right' : 'left'
  end

  def in_navbar?
<<<<<<< d461f1181d8029eb8c6ce395e9b34e6fd6e0e0db
    # returns true if the page is in its website's navbar
    navbar_links = website.arranged_nav_links(:header)
    # ^ navigation links currently in this webpage's website's navbar
    navbar_links.each do |nav_link|
      if nav_link.kind == "dropdown"
        # get children of dropdown links and check them
        nav_link.cached_children.each do |child_link|
          if nav_links.include? child_link
            return true
          end
        end
      end
      if nav_links.include? nav_link
=======
    navbar_links = website.arranged_nav_links(:header)
    # ^ navigation links currently in this webpage's website's navbar
    nav_links.each do |nav_link|
      if navbar_links.include? nav_link
        # the page is in its website's navbar
>>>>>>> basic class method to check if page is in navbar
        return true
      end
    end
    return false
  end
end
