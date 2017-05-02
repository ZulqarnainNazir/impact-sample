class Post < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  include PlacedImageConcern
  include ContentSlugConcern

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

  validates_presence_of :published_on, if: :not_draft?
  validates_presence_of :title
  validates_length_of :post_sections, minimum: 1, message: "minimum is 1", if: :not_draft?

  if ENV['REDUCE_ELASTICSEARCH_REPLICAS'].present?
    settings index: { number_of_shards: 1, number_of_replicas: 0 } do
      mapping do

        indexes :business_id, type: "long"
        indexes :content_category_ids, type: "long"
        indexes :content_tag_ids, type: "long"
        indexes :created_at, type: "date", format: "dateOptionalTime"
        indexes :facebook_id, type: "string"
        indexes :id, type: "long"
        indexes :meta_description, type: "string"
        indexes :published_on, type: "date", format: "dateOptionalTime"
        indexes :published_status, type: "boolean"
        indexes :slug, type: "string"
        indexes :sorting_date, type: "date", format: "dateOptionalTime"
        indexes :title, type: "string"
        indexes :updated_at, type: "date", format: "dateOptionalTime"

        indexes :post_sections, :type => 'nested' do
          indexes :ancestry, type: "string"
          indexes :content, type: "string"
          indexes :created_at, type: "date", format: "dateOptionalTime"
          indexes :heading, type: "string"
          indexes :id, type: "long"
          indexes :kind, type: "string"
          indexes :position, type: "long"
          indexes :post_id, type: "long"
          indexes :updated_at, type: "date", format: "dateOptionalTime"
        end
      end
    end
  end

  def not_draft?
    self.published_status
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

  def default_published_on
    self.published_on ||= self.created_at
  end

  def as_indexed_json(options = {})
    as_json(
      methods: %i[content_category_ids content_tag_ids sorting_date content heading],
      include: { post_sections: {only: [:content, :heading, :ancestry, :created_at, :id, :kind, :position, :post_id, :updated_at]} }
    )
  end

  def share_callback_url
    if self.business.webhost_primary? && !self.business.is_on_engage_plan?
      url_for("http://#{website_host(self.business.website)}/#{path_to_external_content(self)}")
    elsif self.business.is_on_engage_plan?
      "http://#{ENV['LISTING_HOST']}#{self.business.generate_listing_path}/#{self.slug}?content=post"
    end  
  end

  def arranged_sections
    sections = false
    p = post_sections.each do |f|
      if !f.position.nil? && f.position.integer? && f.position > 0
        sections = true
      end
    end
    if sections == false
      post_sections.arrange(order: :id).map do |section, arrangement|
        add_cached_children(section, arrangement)
      end
    elsif sections == true
      post_sections.arrange(order: :position).map do |section, arrangement|
        add_cached_children(section, arrangement)
      end
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

  def sections_html
    html = ''
    add_sections_html html, post_sections.arrange(order: :position)
    html
  end

  def sections_content
    content = ''
    add_sections_content content, arranged_sections
    content
  end

  def sections_placement
    find_sections_placement post_sections.arrange(order: :position)
  end

  def share_image_url
    self.post_sections.find { |ps| ps.post_section_image }.try(:post_section_image).try(:attachment_full_url, :jumbo)
  end

  def image_size
    FastImage.size(self.share_image_url)
  end

  def has_section_image?
    self.post_sections.find { |ps| ps.post_section_image }.try(:post_section_image).try(:attachment_url, :jumbo).nil?
  end

  def sorting_date
    #change made to published_at, see comments there as of 2.16.17
    published_at
  end

  def published_at
    #method was originaly designed to provide published_on dates, and in lieu of that,
    #updated_at. This is used primarily for searches and ordering via ElasticSearch,
    #but may also be used elsewhere. The method was changed on 2.16.17 to use created_at
    #if published_on is nil. published_on is usually nil with older posts. This is because
    #published_on was implemented in October 2016, when there were already posts present.
    #using created_at is a workaround for old posts that don't have a published_on value.
    published_on || created_at
  end

  def to_generic_param
    {
      year: published_at.strftime('%Y'),
      month: published_at.strftime('%m'),
      day: published_at.strftime('%d'),
      id: id,
      slug: slug
    }
  end

  def to_generic_param_two
    [
      published_at.strftime('%Y').to_s,
      published_at.strftime('%m').to_s,
      published_at.strftime('%d').to_s,
      "#{id}",
      slug.to_s
    ]
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
      if a.position.nil? && b.position.nil?
        a.id.to_i <=> b.id.to_i
      else
        a.position.to_i <=> b.position.to_i
      end
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
    return if sections.nil?
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
