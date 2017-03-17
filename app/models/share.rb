class Share < ActiveRecord::Base
	belongs_to :shareable, polymorphic: true
	has_one :schedule
end
