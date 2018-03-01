class PopulateToDoComment

  def self.run(todo, user)
    puts "Populating To Do Comment..."

    ToDoComment.create!(
      commenter_id: user.id,
      to_do_id: todo.id,
      content: Faker::Lorem.sentence
    )
  end
end
