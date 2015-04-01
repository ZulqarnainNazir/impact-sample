json.browserButtonsSrc image_path('browser-buttons.png')

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
json.initialSpecialtyBlock      home_page.specialty_block.try(:react_attributes)
json.initialTaglineBlock        home_page.tagline_block.try(:react_attributes)

json.defaultHeroBlockAttributes     home_page.default_hero_block_attributes(business)
json.defaultTaglineBlockAttributes  home_page.default_tagline_block_attributes(business)
