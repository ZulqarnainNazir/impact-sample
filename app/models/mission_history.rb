class MissionHistory < ActiveRecord::Base
  belongs_to :mission_instance
  belongs_to :actor, class_name: 'User'
  belongs_to :trackable, polymorphic: true

  has_one :note, as: :notable, dependent: :destroy

  scope :newest, -> { order('created_at DESC') }
  scope :mission_historical, -> { where(action: ['completed', 'skipped', 'activated']) }
  scope :for_business, -> (business) { where(mission_instance_id: business.mission_instances.map(&:id)) }
  scope :activations, -> { where action: 'activated' }

  validates :action, :mission_instance, presence: true

  def completed?
    action == 'completed'
  end

  def skipped?
    action == 'skipped'
  end

  def actor_name
    actor_id? ? actor.name : 'System'
  end
end
