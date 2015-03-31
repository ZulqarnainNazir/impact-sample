class Location < ActiveRecord::Base
  belongs_to :business, touch: true

  has_many :openings, dependent: :destroy

  accepts_nested_attributes_for :openings, allow_destroy: true, reject_if: proc { |a| a['id'].nil? && %w[opens_at closes_at sunday monday tuesday wendesday thursday friday saturday].all? { |at| a[at].blank? } || a['_destroy'].blank? }

  validates :state, inclusion: { in: UsStates.abbreviations }, allow_blank: true

  def attributes_with_address
    attributes.merge(
      address_line_one: address_line_one,
      address_line_two: address_line_two,
    )
  end

  def address_line_one
    [street1, street2].reject(&:blank?).join(', ')
  end

  def address_line_two
    "#{city}, #{state} #{zip_code}"
  end
end
