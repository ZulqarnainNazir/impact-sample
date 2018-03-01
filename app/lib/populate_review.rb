class PopulateReview

  def self.run(business)
    puts "Populating Review..."

    contact = business.contacts.create!(
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.first_name,
      email: Faker::Internet.email,
    )

    business.reviews.create!(
      business: business,
      contact: contact,
      customer_email: Faker::Internet.email,
      customer_name: Faker::Name.name,
      description: Faker::Lorem.sentence,
      overall_rating: 4,
      reviewed_at: Time.now
    )
  end
end
