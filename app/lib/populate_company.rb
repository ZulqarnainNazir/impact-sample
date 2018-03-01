class PopulateCompany

  def self.run(name = Faker::Company.name)
    puts "Populating Company..."

    Company.create!(
      name: name,
      company_location: CompanyLocation.new(
        name: Faker::Address.community,
        street1: Faker::Address.street_address,
        city: Faker::Address.city,
        state: Faker::Address.state_abbr,
        zip_code: Faker::Address.zip_code
      )
    )
  end
end
