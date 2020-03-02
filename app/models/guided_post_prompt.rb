class GuidedPostPrompt < ActiveRecord::Base

  enum post_type: {creation_post: 0}
  enum section_type: {title: 0, main_image: 1, intro_section: 2, main_section: 3, other_section: 4, outcome_section: 5, cta_section: 6 }
  enum industry: {general: 0, professional_services: 1, retail: 2, restaurant: 3 }

  # scope :admin_created, -> { where(business_id: nil) }
  # scope :recommended, -> { where(globally_recommended: true) }

  validates :prompt, :description, :post_type, :section_type, :industry, presence: true
  validates :post_type, uniqueness: {scope: [:section_type, :industry]}, unless: Proc.new { |guided_post_prompt| guided_post_prompt.section_type == 'other_section' }
  # validates :post_type, uniqueness: {scope: [:industry]}

  private

end
