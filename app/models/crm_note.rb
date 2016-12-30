class CrmNote < ActiveRecord::Base
  belongs_to :contact
  belongs_to :company

  validates :content, presence: true
  validates :user_name, presence: true

  def self.default_scope
    order(created_at: :desc)
  end
end
