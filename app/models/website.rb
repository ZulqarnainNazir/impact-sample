class Website < ActiveRecord::Base
  belongs_to :business, touch: true

  has_many :pages, dependent: :destroy
  has_many :webhosts, dependent: :destroy

  has_one :home_page
  has_one :about_page
  has_one :contact_page
  has_one :active_home_page, -> { active }, class_name: HomePage.name
  has_one :active_about_page, -> { active }, class_name: AboutPage.name
  has_one :active_contact_page, -> { active }, class_name: ContactPage.name

  accepts_nested_attributes_for :webhosts, allow_destroy: true, reject_if: proc { |a| a['id'].nil? && a['name'].blank? || a['_destroy'].blank? }

  store_accessor :settings,
    :footer,
    :header,
    :header_style

  validates :footer, presence: true, inclusion: { in: %w[simple simpleFullWidth columns layers] }
  validates :header, presence: true, inclusion: { in: %w[inline center justify logoAbove logoAboveFullWidth logoBelow logoCenter] }
  validates :header_style, presence: true, inclusion: { in: %w[dark light transparent] }
  validates :subdomain, presence: true, length: { in: 3..30 }, format: { with: /\A[[a-z][0-9]\-]+\z/ }, uniqueness: { case_sensitive: false }
  validates :webhosts, length: { maximum: 10 }

  validate do
    if webhosts.reject(&:marked_for_destruction?).length > 1 && webhosts.reject(&:marked_for_destruction?).select(&:primary?).length != 1
      errors.add :webhosts, :invalid_primary
    end
  end

  def header_class
    case header_style
    when 'dark'
      'navbar-inverse'
    when 'light'
      'navbar-default'
    end
  end

  def webhost
    webhosts.length > 1 ? webhosts.primary.first : webhosts.first
  end
end
