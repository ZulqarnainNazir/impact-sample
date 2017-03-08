class ToDoList < ActiveRecord::Base
  has_many :missions

  validates :name, presence: true
end
