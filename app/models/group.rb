class Group < ActiveRecord::Base
  belongs_to :webpage

  has_many :blocks, as: :frame, dependent: :destroy

  validates :type, presence: true
  validates :blocks, presence: true

  def self.default_scope
    order(position: :asc, created_at: :asc)
  end
end
