module ContentSlugConcern
  extend ActiveSupport::Concern

  included do
    validates :slug, presence: true
    before_validation :generate_slug, on: :create
  end

  def generate_slug
    self.slug = find_available_slug(title.gsub(/['’]/, '').parameterize, 1) if title.present?
  end

  private

  def find_available_slug(slug, n)
    if n == 1
      test_slug = slug
    else
      test_slug = "#{slug}-#{n}"
    end

    duplicate = false
    duplicate = true if business.before_afters.where(slug: test_slug).any?
    duplicate = true if business.event_definitions.where(slug: test_slug).any?
    duplicate = true if business.galleries.where(slug: test_slug).any?
    duplicate = true if business.offers.where(slug: test_slug).any?
    duplicate = true if business.posts.where(slug: test_slug).any?
    duplicate = true if business.quick_posts.where(slug: test_slug).any?

    if duplicate
      find_available_slug(slug, n + 1)
    else
      test_slug
    end
  end
end
