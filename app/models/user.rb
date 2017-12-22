class User < ActiveRecord::Base
  mailkick_user #determines (and sets status as) if a user has requested "unsubscribe" from emails

  Mailkick.user_method = -> (email) { User.find_by(email: email) }

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
  has_many :invites,
    foreign_key: :inviter_id

  devise *%i[confirmable database_authenticatable lockable registerable recoverable rememberable trackable validatable masqueradable]

  attr_accessor :honey

  validates :first_name, presence: true
  validates :last_name, presence: true

  def sent_invite?
    invites.size > 0
  end

  def invite_sent_email?(email)
    @email = email
    return AhoyMessage.invite_sent_check?(self.id, @email)
  end

  def find_invite_by_invitee_id(email, business, invitee_id)
    #the purpose is to return an invite if it is found, and if not, return nil
    #as of creation, used in invites_controller#create.rb
    @invitee_id = invitee_id
    @email = email
    @business = business
    @contacts = @business.contacts.where(email: @email)
    @result = nil

    #if there is an invitee_id argued, and if it is in an invite sent by the user, return the contact
    if !@invitee_id.blank?
      if self.invites.where(invitee_id: @invitee_id).present?
        return self.invites.where(invitee_id: @invitee_id).first.invitee #this returns a contact
      else
        return @result
      end
    end
    #no invitee_id present? then search contacts by email
    # if @contacts.count == 0
    #   return nil
    # elsif @contacts.count > 0
    #   @contacts.each do |record|
    #     if self.invites.where(email: record.email)
    #       @result = record
    #     end
    #   end
    #   return @result
    # end
  end

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

  def save(*args)
    honey.present? ? true : super
  end
end
