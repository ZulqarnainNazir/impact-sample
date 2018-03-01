class PopulateComment

  def self.run(entity, user)
    puts "Populating Comment..."

    Comment.create!(
      commenter: user,
      commentable: entity,
      content: Faker::Lorem.sentence
    )
  end
end
