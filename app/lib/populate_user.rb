class PopulateUser

  def self.run
    puts "Populating User..."

    User.create!(
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      email: Faker::Internet.email,
      password: "password",
    )
  end
end
