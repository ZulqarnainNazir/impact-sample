json.browserButtonsSrc image_path('browser-buttons.png')

s3_presigned_post.tap do |presigned_post|
  json.presignedPostHost presigned_post.url.host
  json.presignedPostURL presigned_post.url.to_s
  json.presignedPostFields presigned_post.fields
end

json.internalWebpages business.website.webpages.select(:id, :name)

json.initialCallToActionBlocks  custom_page.call_to_action_blocks.map(&:react_attributes)
json.initialContentBlocks       custom_page.content_blocks.map(&:react_attributes)
json.initialHeroBlock           custom_page.hero_block.try(:react_attributes)
json.initialSpecialtyBlock      custom_page.specialty_block.try(:react_attributes)
json.initialTaglineBlock        custom_page.tagline_block.try(:react_attributes)
