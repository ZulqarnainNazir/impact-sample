class CustomPage < Webpage
  with_options as: :frame, dependent: :destroy do
    has_many :call_to_action_blocks
    has_many :content_blocks
    has_many :specialty_blocks
    has_many :tagline_blocks
    has_one :hero_block
  end

  with_options allow_destroy: true, reject_if: :all_blank do
    accepts_nested_attributes_for :hero_block
    accepts_nested_attributes_for :tagline_blocks
    accepts_nested_attributes_for :specialty_blocks
    accepts_nested_attributes_for :call_to_action_blocks
    accepts_nested_attributes_for :content_blocks
  end
end
