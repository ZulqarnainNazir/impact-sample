class Contact < ActiveRecord::Base
  belongs_to :business

  serialize :relationship

  with_options dependent: :destroy do
    has_many :contact_messages
    has_many :crm_notes
    has_many :feedbacks
    has_many :reviews
    has_many :contact_companies, :dependent => :destroy
  end

  has_many :companies, :through => :contact_companies 

  has_one :feedback, -> { order('CASE WHEN score IS NULL THEN 0 ELSE 1 END ASC, completed_at DESC') }

  accepts_nested_attributes_for :crm_notes, reject_if: :all_blank
  accepts_nested_attributes_for :feedbacks, allow_destroy: true

  validates :business, presence: true
#  validates :first_name, presence: true
#  validates :last_name, presence: true
  validate :name_and_or_email

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

  def self.get_duplicates business, new_contacts, skip_indexes
    Rails.logger.debug "SKIPPING: "
    Rails.logger.debug skip_indexes
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

  def self.get_duplicate business, new_contact
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

  private

  def name_and_or_email
    if email.blank? and first_name.blank? and last_name.blank?
      errors.add(:base, "must provide first name, last name or email")
    end
  end

end
