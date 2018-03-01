class PopulateBusiness

  def self.run(user = nil)
    puts "Populating Business..."

    business_name = Faker::Company.name

    business = Business.create(
      name: business_name,
      website: Website.new(
        footer_block: FooterBlock.new,
        header_block: HeaderBlock.new,
        subdomain: Faker::Internet.domain_word
      ),
      location: Location.new(
        name: Faker::Address.community,
        street1: Faker::Address.street_address,
        city: Faker::Address.city,
        state: Faker::Address.state_abbr,
        zip_code: Faker::Address.zip_code
      ),
      company: PopulateCompany.run(business_name)
    )

    if user
      Authorization.create!(
        business: business,
        user: user,
        role: 0,
      )
    end

    business
  end
end
