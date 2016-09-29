class User < ActiveRecord::Base
  store_accessor :settings, :custom_domains, :viewed_dashboard_tour

  has_many :authorizations, dependent: :destroy
  has_many :businesses, through: :authorizations
  has_many :pdfs
  
  has_many :manager_authorizations, -> { manager }, class_name: Authorization.name
  has_many :owner_authorizations, -> { owner }, class_name: Authorization.name

  has_many :managed_businesses, through: :manager_authorizations, source: :business
  has_many :owned_businesses, through: :owner_authorizations, source: :business

  has_many :images

  devise *%i[confirmable database_authenticatable lockable registerable recoverable rememberable trackable validatable]

  validates :first_name, presence: true
  validates :last_name, presence: true

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
