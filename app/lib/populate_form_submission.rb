class PopulateFormSubmission

  def self.run(business)
    puts "Populating FormSubmission..."

    contact = business.contacts.create!(
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.first_name,
      email: Faker::Internet.email,
    )

    form = business.contact_forms.create!(
      name: Faker::Name.name
    )

    business.form_submissions.create!(
      contact: contact,
      contact_form: form
    )
  end
end
