class Post < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  include PlacedImageConcern

  belongs_to :business, touch: true

  has_many :content_categories, through: :content_categorizations
  has_many :content_categorizations, as: :content_item
  has_many :content_taggings, as: :content_item
  has_many :content_tags, through: :content_taggings
  has_many :post_sections, dependent: :destroy

  has_placed_image :main_image

  accepts_nested_attributes_for :post_sections, allow_destroy: true, reject_if: proc { |a|
    a['_destroy'] == '1' || (
      a['title'].blank? &&
      a['description'].blank? &&
      a['post_section_placement_attributes'].kind_of?(Hash) &&
      a['post_section_placement_attributes'].select { |k,_| !%w[kind image_business image_user].include?(k) }.values.all?(&:blank?)
    )
  }

  validates :business, presence: true
  validates :title, presence: true
  validates :published_on, presence: true

  if ENV['REDUCE_ELASTICSEARCH_REPLICAS'].present?
    settings index: { number_of_shards: 1, number_of_replicas: 0 }
  end

  def published_on=(value)
    if value.to_s.split('/').length == 3
      values = value.split('/')
      values = values[-1..-1] + values[0..-2]
      super(Date.parse(values.join('/')))
    else
      super
    end
  end

  def as_indexed_json(options = {})
    as_json(methods: %i[content_category_ids content_tag_ids sorting_date])
  end

  def arranged_sections
    post_sections.arrange(order: :position).map do |section, arrangement|
      add_cached_children(section, arrangement)
    end
  end

  def keyed_arranged_sections
    sections = post_sections.to_a

    sections.each do |section|
      if section.key.blank?
        section.key = SecureRandom.uuid
      end
    end

    sections.each do |section|
      if section.parent_key.blank?
        parent = sections.find { |s| s.persisted? && s.id == section.parent_id }
        section.parent_key = parent.key if parent
      end
    end

    roots = sections.select do |section|
      section.parent_key.blank?
    end

    add_keyed_cached_children roots, sections
  end

  def to_param
    "#{id}-#{title}".parameterize
  end

  def sections_html
    html = ''
    add_sections_html html, post_sections.arrange(order: :position)
    html
  end

  def sections_content
    content = ''
    add_sections_content content, post_sections.arrange(order: :position)
    content
  end

  def sections_placement
    find_sections_placement post_sections.arrange(order: :position)
  end

  def sorting_date
    published_at
  end

  def published_at
    published_on.to_time + created_at.seconds_since_midnight.seconds
  end

  private

  def add_keyed_cached_children(sections, all_sections)
    sections.map do |section|
      children = all_sections.select do |s|
        s.parent_key == section.key
      end
      section.cached_children = add_keyed_cached_children(children, all_sections)
      section
    end.sort do |a, b|
      a.position.to_i <=> b.position.to_i
    end
  end

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

  def find_sections_placement(sections)
    sections.each do |section, children|
      return section.post_section_image_placement if section.post_section_image_placement.present?
      find_sections_placement(children)
    end
    nil
  end
end
