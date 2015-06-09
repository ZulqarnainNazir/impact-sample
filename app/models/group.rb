class Group < ActiveRecord::Base
  belongs_to :webpage

  has_many :blocks, as: :frame, dependent: :destroy

  accepts_nested_attributes_for :blocks, reject_if: :all_blank, allow_destroy: true

  validates :type, presence: true
  validates :blocks, presence: true

  before_validation do
    self.type = 'Group'
  end

  def self.default_scope
    order(position: :asc, created_at: :asc)
  end
end
