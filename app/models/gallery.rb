class Gallery < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :business

  has_many :gallery_images, dependent: :destroy

  accepts_nested_attributes_for :gallery_images, allow_destroy: true, reject_if: proc { |a|
    a['_destroy'] == '1' || (
      a['description'].blank? &&
      a['gallery_image_placement_attributes'].kind_of?(Hash) &&
      a['gallery_image_placement_attributes'].select { |k,_| !%w[image_business image_user].include?(k) }.values.all?(&:blank?)
    )
  }

  validates :business, presence: true
  validates :title, presence: true

  def description_html
    Sanitize.fragment(description.to_s, Sanitize::Config::RELAXED).html_safe
  end
end
