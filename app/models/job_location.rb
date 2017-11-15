class JobLocation < ActiveRecord::Base
  belongs_to :job, touch: true
  belongs_to :location

  validates :location, presence: true
end
