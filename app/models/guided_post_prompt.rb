class GuidedPostPrompt < ActiveRecord::Base

  enum post_type: {creation_post: 0, profile_post: 1}
  enum section_type: {title: 0, main_image: 1, intro_section: 2, main_section: 3, other_section: 4, outcome_section: 5, cta_section: 6 }
  enum industry: {general: 0, professional_services: 1, retail: 2, restaurant: 3 }
  enum kind: {
    image_right: 0,
    image_left: 1,
    full_text: 2,
    full_image: 3,
  }

  # scope :admin_created, -> { where(business_id: nil) }
  # scope :recommended, -> { where(globally_recommended: true) }

  validates :prompt, :description, :post_type, :section_type, :industry, :kind, presence: true
  validates :heading_prompt, presence: true, unless: Proc.new { |guided_post_prompt| guided_post_prompt.section_type == 'title' || guided_post_prompt.section_type == 'main_image' || guided_post_prompt.section_type == 'intro_section' || guided_post_prompt.section_type == 'cta_section' }

  validates :post_type, uniqueness: {scope: [:section_type, :industry]}, unless: Proc.new { |guided_post_prompt| guided_post_prompt.section_type == 'other_section' }
  # validates :post_type, uniqueness: {scope: [:industry]}

  private

end
