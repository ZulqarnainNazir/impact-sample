class User < ActiveRecord::Base
  store_accessor :settings, :custom_domains, :viewed_dashboard_tour

  has_many :authorizations, dependent: :destroy
  has_many :businesses, through: :authorizations
  has_many :pdfs

  has_many :to_do_notification_settings, dependent: :destroy
  has_many :following_businesses, through: :to_do_notification_settings, source: :business

  has_many :manager_authorizations, -> { manager }, class_name: Authorization.name
  has_many :owner_authorizations, -> { owner }, class_name: Authorization.name

  has_many :managed_businesses, through: :manager_authorizations, source: :business
  has_many :owned_businesses, through: :owner_authorizations, source: :business

  has_many :images

  has_many :to_do_comments, as: :commenter

  devise *%i[confirmable database_authenticatable lockable registerable recoverable rememberable trackable validatable]

  validates :first_name, presence: true
  validates :last_name, presence: true

  def authorized_business_owner?(business)
    if self.authorizations.where(business_id: business.id, role: 0).present? || self.super_user?
      return true
    else
      return false
    end
  end

  def self.search(query, constraint)
    if query && query != "" && !constraint.nil?
      if constraint == "email"
        where('LOWER(email) LIKE ?', "%#{query.downcase}%")
      elsif constraint == "last_name"
        where('LOWER(first_name) LIKE ?', "%#{query.downcase}%")
      elsif constraint == "first_name"
        where('LOWER(last_name) LIKE ?', "%#{query.downcase}%")
      end
    elsif query == "" || constraint.nil?
      all
    else
      all
    end
  end

  def self.get_super_users
    where('super_user = ?', true)
  end

  def authorized_businesses
    super_user ? Business.all : businesses
  end

  def name
    [first_name, last_name].reject(&:blank?).join(' ')
  end

  # Send Devise mailers later via ActiveJob.
  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later(wait: 2.seconds)
  end
end
