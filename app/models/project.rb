class Project < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :business

  has_many :project_images, dependent: :destroy

  accepts_nested_attributes_for :project_images, allow_destroy: true, reject_if: :all_blank

  validates :business, presence: true
  validates :title, presence: true

  def description_html
    Sanitize.fragment(description.to_s, Sanitize::Config::RELAXED).html_safe
  end
end
