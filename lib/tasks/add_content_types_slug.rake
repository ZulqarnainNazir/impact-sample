desc 'Add Content Types Slug'
task add_content_types_slug: [:environment] do
  [BeforeAfter, EventDefinition, Gallery, Offer, Post, QuickPost].each do |model|
    model.find_each do |record|
      record.update_column :slug, record.generate_slug
    end
  end
end
