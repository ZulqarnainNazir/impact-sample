class Location < ActiveRecord::Base
  belongs_to :business, touch: true

  validates :city, presence: true
  validates :zip_code, presence: true
  validates :state, presence: true, inclusion: { in: UsStates.abbreviations }
  validates :street1, presence: true
  validates :name, presence: true
  validates :phone_number, presence: true

  def address_line_one
    [street1, street2].reject(&:blank?).join(', ')
  end

  def address_line_two
    "#{city}, #{state} #{zip_code}"
  end
end
