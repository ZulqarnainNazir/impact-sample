json.browserButtonsSrc image_path('browser-buttons.png')

json.defaultBackgroundColor custom_page.website.background_color
json.defaultForegroundColor custom_page.website.foreground_color
json.defaultLinkColor custom_page.website.link_color

s3_presigned_post.tap do |presigned_post|
  json.presignedPostHost presigned_post.url.host
  json.presignedPostURL presigned_post.url.to_s
  json.presignedPostFields presigned_post.fields
end

json.imagesPath business_images_path(business)

json.internalWebpages business.website.webpages.select(:id, :name)

json.initialCallToActionBlocks  custom_page.call_to_action_blocks.map(&:react_attributes)
json.initialContentBlocks       custom_page.content_blocks.map(&:react_attributes)
json.initialHeroBlock           custom_page.hero_block.try(:react_attributes)
json.initialSpecialtyBlock      custom_page.specialty_block.try(:react_attributes)
json.initialTaglineBlock        custom_page.tagline_block.try(:react_attributes)
