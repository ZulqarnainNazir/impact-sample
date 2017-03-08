class Mission < ActiveRecord::Base
  GROUP_OPTIONS = %w(quickstart operational industry general).freeze
  TIER_OPTIONS = %w(recurring setup foundational presence scheduled).freeze
  DIFFICULTY_OPTIONS = %w(easy medium hard).freeze
  PILLARS_OPTIONS = %w(Farm Harvest Hunt Gather).freeze
  INDUSTRY_OPTIONS = %w(General Restaurant Boutique Construction).freeze

  belongs_to :business
  belongs_to :to_do_list

  before_save :sanitize_repetition

  has_many :mission_instances do
    def for_business(business_id)
      find_by(business_id: business_id)
    end

    def all_for_business(business_id)
      where(business_id: business_id)
    end
  end

  accepts_nested_attributes_for :mission_instances

  belongs_to :assigned_user, class_name: 'User'
  belongs_to :creating_user, class_name: 'User'

  enum status: [:active, :inactive]
  enum prompt_type: [:simple, :scheduled]

  scope :admin_created, -> { where(business_id: nil) }
  scope :recommended, -> { where(globally_recommended: true) }

  store_accessor :settings, :desktop, :mobile

  validates :title, :description, presence: true
  validates :time_to_complete, presence: true, unless: :business_id?

  before_save :set_prompt_type, :sanitize_pillars

  def schedule
    if repetition?
      IceCube::Schedule.new(created_at).tap do |s|
        s.add_recurrence_rule RecurringSelect.dirty_hash_to_rule(repetition)
      end
    end
  end

  def next_due_at
    Time.now
  end

  def activated_at
    nil
  end

  def self.reminders_for_business(business)
    where(business_id: [nil, business.id])
  end

  def self.recommended_for_business(business, exclude_ids)
    # Admin recommended missions
    admin_created.recommended.where.not(id: exclude_ids)
  end

  def admin_created?
    business_id.nil?
  end

  def user_created?
    business_id.present?
  end

  def upcoming_due_date
    next_due_at + target_frequency_days.days
  end

  private

  def set_prompt_type
    self.prompt_type = 'scheduled' if repetition.present?
  end

  def sanitize_pillars
    self.pillars = Array(pillars).reject { |value| value.blank? }
  end

  def sanitize_repetition
    self.repetition = nil if repetition == 'null'
  end
end
