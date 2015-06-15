class ContactMessage < ActiveRecord::Base
  attr_accessor :honey

  belongs_to :business

  validates :business, presence: true
  validates :name, presence: true
  validates :email, presence: true
  validates :message, presence: true

  after_create do
    business.authorizations.includes(:user).where(contact_message_notifications: true).each do |authorization|
      AuthorizationsMailer.contact_message_notification(authorization, self).deliver_later
    end
  end

  def self.chronological
    order(created_at: :desc)
  end

  def save(*args)
    honey.present? ? true : super
  end
end
