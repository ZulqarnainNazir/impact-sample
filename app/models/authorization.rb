class Authorization < ActiveRecord::Base
  belongs_to :business
  belongs_to :user

  enum role: { owner: 0 }

  validates :business, presence: true
  validates :role, presence: true
  validates :user, presence: true, uniqueness: { scope: :business }

  accepts_nested_attributes_for :user, reject_if: :all_blank

  after_commit do
    AuthorizationsMailer.owner_welcome(self).deliver_later(wait: 10.seconds)
  end

  def self.alphabetical
    joins(:user).order('LOWER(users.last_name) ASC, LOWER(users.first_name) ASC')
  end
end
