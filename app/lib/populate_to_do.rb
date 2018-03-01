class PopulateToDo

  def self.run(business)
    puts "Populating To Do Comment..."

    ToDo.create!(
      title: Faker::Lorem.sentence,
      description: Faker::Lorem.sentence,
      business: business
    )
  end
end
