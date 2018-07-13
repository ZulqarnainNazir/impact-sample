class Authorization < ActiveRecord::Base
  belongs_to :business
  belongs_to :user

  enum role: { owner: 0, manager: 1 }

  validates :business, presence: true
  validates :role, presence: true
  validates :user, presence: true, uniqueness: { scope: :business }

  accepts_nested_attributes_for :user, reject_if: :all_blank

  before_validation on: :invite do
    existing_user = User.find_by_email(user.try(:email))

    if existing_user
      existing_user.invited_to_account = true
      self.user = existing_user
      AuthorizationsMailer.welcome(self).deliver_now
    else
      self.user.tap do |user|
        def user.password_required?
          false
        end
        user.invited_to_account = true
      end
    end
  end

  after_create do
    # AuthorizationsMailer.owner_welcome(self).deliver_now #.deliver_later(wait: 10.seconds)

    # We skipped sending the authorization earlier, so send it once we link user to a business
    self.user.send_confirmation_instructions unless self.user.confirmed?
  end

  def self.alphabetical
    joins(:user).order('LOWER(users.last_name) ASC, LOWER(users.first_name) ASC')
  end

end
