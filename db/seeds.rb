[
  'Faith & Religion',
  'Nightlife',
  'Landmarks',
  'Legal Services',
  'Automotive',
  'Baby & Maternity',
  'Parenting & Family',
  'Government & Civic',
  'Schools & Education',
  'Pets',
  'Beauty & Personal Care',
  'Professional Services',
  'Nonprofits',
  'Travel and Accommodations',
  'Real Estate',
  'Shopping & Retail',
  'Sports & Recreation',
  'Gifts',
  'Formal Wear',
  'Arts & Entertainment',
  'Insurance',
  'Restaurants',
  'Home & Garden',
  'Weddings & Parties',
  'Health & Wellness',
  'Parks and Recreational Facilities',
  'Media/News/Publishing',
  'Food & Beverage',
  'Other Services',
].each do |category_name|
  Category.create(name: category_name)
end
