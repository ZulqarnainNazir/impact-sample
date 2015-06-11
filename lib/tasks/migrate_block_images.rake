desc 'Migrate block images'
task migrate_block_images: [:environment] do
  ActiveRecord::Base.connection.execute("UPDATE placements SET context = 'block_background' WHERE context = 'hero_block_image'")
  ActiveRecord::Base.connection.execute("UPDATE placements SET context = 'block_image' WHERE context = 'about_block_image'")
  ActiveRecord::Base.connection.execute("UPDATE placements SET context = 'block_image' WHERE context = 'call_to_action_block_image'")
  ActiveRecord::Base.connection.execute("UPDATE placements SET context = 'block_image' WHERE context = 'content_block_image'")
  ActiveRecord::Base.connection.execute("UPDATE placements SET context = 'block_image' WHERE context = 'sidebar_content_block_image'")
  ActiveRecord::Base.connection.execute("UPDATE placements SET context = 'block_image' WHERE context = 'specialty_block_image'")
end
