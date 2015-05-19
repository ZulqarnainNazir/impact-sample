desc 'Migrate categories data'
task migrate_categories: [:environment] do
  ActiveRecord::Base.transaction do
    keep_category 'Arts & Entertainment'
    keep_category 'Automotive'
    keep_category 'Beauty & Personal Care'
    keep_category 'Faith & Religion'
    keep_category 'Health & Wellness'
    keep_category 'Insurance'
    keep_category 'Nonprofits'
    keep_category 'Professional Services'
    keep_category 'Real Estate'
    keep_category 'Schools & Education'
    keep_category 'Shopping & Retail'
    keep_category 'Sports & Recreation'
    keep_category 'Weddings & Parties'

    rename_category 'Government & Civic', 'Public Service, Government & Civic'
    rename_category 'Home & Garden', 'Home Improvement, Garden & Home Services'
    rename_category 'Media/News/Publishing', 'Media, News & Publishing'
    rename_category 'Nightlife', 'Bars, Lounges & Clubs'
    rename_category 'Other Services', 'Other'
    rename_category 'Parenting & Family', 'Parenting & Family Services'
    rename_category 'Pets', 'Pet Services'
    rename_category 'Restaurants', 'Food & Dining'
    rename_category 'Travel And Accommodations', 'Travel & Destinations'

    create_category 'Community Centers'
    create_category 'Medical Services'

    merge_category 'Baby & Maternity', 'Health & Wellness'
    merge_category 'Food & Beverage', 'Food & Dining'
    merge_category 'Formal Wear', 'Weddings & Parties'
    merge_category 'Gifts', 'Shopping & Retail'
    merge_category 'Landmarks', 'Travel & Destinations'
    merge_category 'Legal Services', 'Professional Services'
    merge_category 'Parks And Recreational Facilities', 'Sports & Recreation'
  end
end

def keep_category(name)
  Category.find_by_name!(name)
end

def rename_category(name, new_name)
  Category.find_by_name!(name).update(name: new_name, pathname: new_name.parameterize)
end

def create_category(name)
  Category.create!(name: name)
end

def merge_category(merge_name, target_name)
  merge = Category.find_by_name!(merge_name)
  target = Category.find_by_name!(target_name)
  target.business_ids = [target.business_ids, merge.business_ids].flatten.uniq
  merge.destroy!
end
