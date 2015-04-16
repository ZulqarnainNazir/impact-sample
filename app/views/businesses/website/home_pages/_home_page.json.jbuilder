json.browserButtonsSrc image_path('browser-buttons.png')

json.defaultBackgroundColor home_page.website.background_color
json.defaultForegroundColor home_page.website.foreground_color
json.defaultLinkColor home_page.website.link_color

s3_presigned_post.tap do |presigned_post|
  json.presignedPostHost presigned_post.url.host
  json.presignedPostURL presigned_post.url.to_s
  json.presignedPostFields presigned_post.fields
end

json.imagesPath business_images_path(business)

json.internalWebpages business.website.webpages.select(:id, :name)

json.initialCallToActionBlocks  home_page.call_to_action_blocks.map(&:react_attributes)
json.initialContentBlocks       home_page.content_blocks.map(&:react_attributes)
json.initialHeroBlock           home_page.hero_block.try(:react_attributes)
json.initialSpecialtyBlocks     home_page.specialty_blocks.map(&:react_attributes)
json.initialTaglineBlocks       home_page.tagline_blocks.map(&:react_attributes)

json.defaultHeroBlockAttributes     home_page.default_hero_block_attributes(business)
json.defaultTaglineBlockAttributes  home_page.default_tagline_block_attributes(business)
