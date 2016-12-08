require 'test_helper'

class ToDoTest < ActiveSupport::TestCase
  should validate_presence_of(:title)
  should validate_presence_of(:description)
end
