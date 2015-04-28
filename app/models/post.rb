class Post < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :business

  has_many :post_sections, dependent: :destroy

  accepts_nested_attributes_for :post_sections, allow_destroy: true, reject_if: proc { |a|
    a['_destroy'] == '1' || (
      a['title'].blank? &&
      a['description'].blank? &&
      a['post_section_placement_attributes'].kind_of?(Hash) &&
      a['post_section_placement_attributes'].select { |k,_| !%w[image_business image_user].include?(k) }.values.all?(&:blank?)
    )
  }

  validates :business, presence: true
  validates :title, presence: true

  def arranged_sections
    post_sections.arrange(order: :position).map do |section, arrangement|
      add_cached_children(section, arrangement)
    end
  end

  def to_param
    "#{id}-#{title}".parameterize
  end

  def sections_html
    html = ''
    add_sections_html html, post_sections.arrange(order: :position)
    Sanitize.fragment(html, Sanitize::Config::RELAXED).html_safe
  end

  def sections_content
    content = ''
    add_sections_content content, post_sections.arrange(order: :position)
    Sanitize.fragment(content)
  end

  private

  def add_cached_children(section, arrangement)
    section.cached_children = arrangement.keys
    arrangement.each do |section, arrangement|
      add_cached_children(section, arrangement)
    end
    section
  end

  def add_sections_html(html, sections, level = 2)
    sections.each do |section, children|
      html << "<h#{level}>#{section.heading}</h#{level}>"
      html << " #{section.content} "
      add_sections_html(html, children, level + 1)
    end
  end

  def add_sections_content(content, sections)
    sections.each do |section, children|
      content << " #{section.content} "
      add_sections_content(content, children)
    end
  end
end
