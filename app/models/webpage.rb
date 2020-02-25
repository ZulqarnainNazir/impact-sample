class Webpage < ActiveRecord::Base
  include PlacedImageConcern

  store_accessor :settings, :external_line_id, :sidebar_position, :page_head_injection

  attr_accessor :skip_clone_validation

  belongs_to :website

  has_many :groups, dependent: :destroy
  has_many :linked_blocks, as: :link, class_name: Block.name
  has_many :nav_links, dependent: :destroy

  has_many   :cloned_pages, class_name: 'Webpage', foreign_key: 'cloned_from_id'
  belongs_to :cloned_page,  class_name: 'Webpage'

  has_placed_image :main_image

  with_options allow_destroy: true, reject_if: :all_blank do
    accepts_nested_attributes_for :groups
  end

  validates :pathname, uniqueness: { scope: :website, case_sensitive: false }, unless: -> { skip_pathname_validation? }
  validates :pathname, absence: true, if: -> { type == 'HomePage' }
  validates :pathname, presence: true, format: { with: /\A\w+[\w\-\/]*\w+\z/ }, unless: -> { skip_pathname_validation? }
  validates :title, presence: true, unless: :skip_clone_validation, unless: -> { :skip_clone_validation }
  validates :type, presence: true, exclusion: { in: %w[Webpage] }

  before_validation do
    self.name = title if !name? && title?
    self.pathname = set_pathame
  end

  def self.custom
    where(type: 'CustomPage')
  end

  def clone!
    if cloneable?
      cloned_webpage = dup
      cloned_webpage.groups << groups.map(&:clone!)
      cloned_webpage.linked_blocks << linked_blocks.map(&:clone!)
      cloned_webpage.nav_links << nav_links.map(&:clone!)
      # FIXME: not sure what to do with this yet
      cloned_webpage.main_image = main_image.clone!
      cloned_webpage.cloned_from_id = id
      cloned_webpage.pathname = nil
      cloned_webpage.type = 'CustomPage'
      cloned_webpage.title = ''
      cloned_webpage.skip_clone_validation = true
      cloned_webpage.save!
      return cloned_webpage
    end
  end

  def cloneable?
    %w[HomePage CustomPage].include? type
  end

  def main_image
    super.try(:attachment_url, :jumbo) ||
      Block.where(type: 'HeroBlock', frame_type: 'Group', frame_id: group_ids).first.try(:block_background).try(:attachment_url, :jumbo) ||
      Block.where(type: 'HeroBlock', frame_type: 'Group', frame_id: group_ids).first.try(:block_image).try(:attachment_url, :jumbo) ||
      Block.where(type: 'ContentBlock', frame_type: 'Group', frame_id: group_ids).first.try(:block_image).try(:attachment_url, :jumbo)
  end

  def set_pathame
    unless type == 'HomePage'
      if !pathname? && title?
        if cloned_from_id.present? && skip_clone_validation
          ''
        else
          title.parameterize
        end
      else
        pathname
      end
    end
  end

  def sidebar_position
    super == 'left' ? 'left' : 'right'
  end

  def sidebar_reverse_position
    sidebar_position == 'left' ? 'right' : 'left'
  end

  def skip_pathname_validation?
    skip_clone_validation || type == 'HomePage'
  end

  def in_navbar?
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
        return true
      end
    end
    return false
  end
end
