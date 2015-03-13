class Opening < ActiveRecord::Base
  belongs_to :location, touch: true
end
