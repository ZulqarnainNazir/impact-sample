class ToDoList < ActiveRecord::Base
  has_many :missions
  belongs_to :business

  validates :name, presence: true

  def self.for_business(business)
    where business_id: [business.id, nil]
  end

  def owned_by?(business)
    business_id == business.id
  end

  def authorized_for?(business)
    owned_by?(business) || business_id == nil
  end
end
