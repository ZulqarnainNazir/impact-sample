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
  validates :email, presence: true
  validates :name, presence: true

  def business_url=(value)
    if value.blank? || value.to_s.match(/\Ahttp/)
      super(value.to_s)
    else
      super("http://#{value}")
    end
  end
end
