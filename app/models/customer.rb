class Customer < ActiveRecord::Base
  belongs_to :business

  with_options dependent: :destroy do
    has_many :contact_messages
    has_many :reviews
  end

  validates :business, presence: true
  validates :email, presence: true
  validates :name, presence: true
end
