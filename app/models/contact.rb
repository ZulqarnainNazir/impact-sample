class Contact < ActiveRecord::Base
  belongs_to :business

  serialize :relationship

  with_options dependent: :destroy do
    has_many :contact_messages
    has_many :crm_notes
    has_many :feedbacks
    has_many :reviews
    has_many :contact_companies, :dependent => :destroy
    has_many :form_submissions
  end

  has_many :companies, :through => :contact_companies

  has_one :feedback, -> { order('CASE WHEN score IS NULL THEN 0 ELSE 1 END ASC, completed_at DESC') }

  accepts_nested_attributes_for :crm_notes, reject_if: :all_blank
  accepts_nested_attributes_for :feedbacks, allow_destroy: true

  validates :business, presence: true
#  validates :first_name, presence: true
#  validates :last_name, presence: true
  validate :name_and_or_email

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


  class << self
    def get_duplicates business, new_contacts, skip_indexes
      duplicates = {}
      new_contacts.each_with_index do |new_contact, i|
        if skip_indexes.include?(i.to_s)
          next
        end
        dup = self.get_duplicate business, new_contact
        if dup != false
          duplicates[i] = dup
        end
      end
      if !duplicates.blank?
        duplicates
      end
    end

    def get_duplicate business, new_contact
      matches = []
      if(!new_contact[:first_name].blank? and !new_contact[:last_name].blank?)
        matches += where(:business_id => business.id).where("LOWER(first_name)=LOWER(?) AND LOWER(last_name)=LOWER(?)", new_contact[:first_name], new_contact[:last_name])
      end
      if(!new_contact[:phone].blank?)
        matches += where(:business_id => business.id).where("regexp_replace(phone, '[^0-9]+', '', 'g')=regexp_replace(?, '[^0-9]+', '', 'g')", new_contact[:phone])
      end
      if(!new_contact[:email].blank?)
        matches += where(:business_id => business.id).where("LOWER(email)=LOWER(?)", new_contact[:email])
      end
      if matches.blank?
        return false
      end
      counts = matches.each_with_object(Hash.new(0)) { |o, h| h[o[:id]] += 1 }
      best_match = counts.sort_by {|k,v| v}.reverse[0][0].to_i
      find(best_match)
    end
  end

  def name
    "#{first_name} #{last_name}"
  end

  def business_url=(value)
    if value.blank? || value.to_s.match(/\Ahttp/)
      super(value.to_s)
    else
      super("http://#{value}")
    end
  end

  def get_email_records
    AhoyMessage.where(:to => self.email, :business_id => self.business.id)
  end

  def recent_activities
    # This is a potential performance issue. Most likely this data should be loaded
    # using an async request after page load. There should also be a central Activity
    # model that references these other models in order to allow pagination through
    # the use of limits within a SQL query. This is good enough for now, but as
    # contacts have more and more activity it should most likely be cached then
    # paginated.

    activities = [
      contact_messages.to_a,
      crm_notes.to_a,
      reviews.to_a,
      get_email_records.to_a,
      form_submissions.to_a
    ].flatten!

    activities.sort_by!(&:created_at).reverse!
  end

  def self.find_and_update_or_create contact_hash
    matches = []
    if !contact_hash[:first_name].blank? and !contact_hash[:last_name].blank?
      matches += where('(first_name = ? AND last_name = ?)', contact_hash[:first_name], contact_hash[:last_name])
    end
    if !contact_hash[:email].blank?
      matches += where(:email => contact_hash[:email])
    end
    if !contact_hash[:phone].blank?
      matches += where(:phone => contact_hash[:phone])
    end
    if matches.blank?
      return create(contact_hash)
    end
    counts = matches.each_with_object(Hash.new(0)) { |o, h| h[o[:id]] += 1 }
    best_match_id = counts.sort_by {|k,v| v}.reverse[0][0].to_i
    best_match = find(best_match_id)
    best_match.update_attributes_only_if_blank contact_hash
    best_match
  end

  def update_attributes_only_if_blank(attributes)
    attributes.each { |k,v| attributes.delete(k) unless read_attribute(k).blank? }
    update_attributes(attributes)
  end

  private

  def name_and_or_email
    if email.blank? and first_name.blank? and last_name.blank?
      errors.add(:base, "must provide first name, last name or email")
    end
  end
end
