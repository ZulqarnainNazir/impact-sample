class Alert < ActiveRecord::Base

  belongs_to :business, touch: true

  validates :alert_type, presence: true
  validates :message, length: { maximum: 240 }
  validates_presence_of :message, :unless => lambda {self.alert_type == 'default'}

  enum alert_type: {
    default: 0,
    normal_operations: 1,
    modified_operations: 2,
    temporarily_closed: 3,
  }

end
