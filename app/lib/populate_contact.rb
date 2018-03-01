class PopulateContact

  def self.run(business)
    puts "Populating Contact..."

    business.contacts.create!(
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.first_name,
      email: Faker::Internet.email,
    )
  end
end
