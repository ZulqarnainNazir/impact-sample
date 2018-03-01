class PopulateMissionInstance

  def self.run(business, num)
    puts "Populating Mission Instance..."

    instances = []
    num.times do |n|
      instances << MissionInstance.create!(
        business: business,
        start_date: Date.today,
        mission: Mission.create!(
          title: Faker::Book.title,
          description: Faker::Lorem.sentence,
          time_to_complete: Faker::Time.forward(Faker::Number.number(1).to_i, :morning)
        )
      )
    end

    3.times do |n|
      instances[n].mark_complete
    end
    
    instances
  end
end
