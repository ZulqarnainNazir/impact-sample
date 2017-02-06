[
  'Arts & Entertainment',
  'Automotive',
  'Bars, Lounges & Clubs',
  'Beauty & Personal Care',
  'Community Centers',
  'Faith & Religion',
  'Food & Dining',
  'Health & Wellness',
  'Home Improvement, Garden & Home Services',
  'Insurance',
  'Media, News & Publishing',
  'Medical Services',
  'Nonprofits',
  'Other',
  'Parenting & Family Services',
  'Pet Services',
  'Professional Services',
  'Public Service, Government & Civic',
  'Real Estate',
  'Schools & Education',
  'Shopping & Retail',
  'Sports & Recreation',
  'Travel & Destinations',
  'Weddings & Parties',
].each do |category_name|
  Category.create!(name: category_name)
end

case Rails.env
when "development"
  User.create!(
    first_name: "Dev",
    last_name: "Admin",
    email: "dev@email.com",
    super_user: true,
    password: "password",
  )
when "production"

end
