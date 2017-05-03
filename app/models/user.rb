class User < ActiveRecord::Base
  store_accessor :settings, :custom_domains, :viewed_dashboard_tour

  has_many :messages, class_name: "Ahoy::Message"

  has_many :authorizations, dependent: :destroy
  has_many :businesses, through: :authorizations
  has_many :pdfs

  has_one :mission_notification_setting

  has_many :to_do_notification_settings, dependent: :destroy
  has_many :following_businesses, through: :to_do_notification_settings, source: :business

  has_many :manager_authorizations, -> { manager }, class_name: Authorization.name
  has_many :owner_authorizations, -> { owner }, class_name: Authorization.name

  has_many :managed_businesses, through: :manager_authorizations, source: :business
  has_many :owned_businesses, through: :owner_authorizations, source: :business

  has_many :images

  has_many :to_do_comments, as: :commenter

  devise *%i[confirmable database_authenticatable lockable registerable recoverable rememberable trackable validatable masqueradable]

  validates :first_name, presence: true
  validates :last_name, presence: true

  def complaint_or_bounce_report
    if self.complaint_report?
      "Emails to this address have been marked as spam."
    elsif self.bounce_report?
      "This address is not accepting emails (error: email bounce)."
    else
      "This address is accepting emails."
    end
  end

  def bounce_or_complaint?
    if self.bounce_report? || self.complaint_report?
      true
    else
      false
    end
  end

  def bounce_report?
    bounce_report = BouncedEmail.find_by(email_address: self.email)
    if bounce_report.nil?
      false
    elsif !bounce_report.nil?
      true
    end
  end

  def complaint_report?
    complaint_report = ComplaintsEmail.find_by(email_address: self.email)
    if complaint_report.nil?
      false
    elsif !complaint_report.nil?
      true
    end
  end

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
