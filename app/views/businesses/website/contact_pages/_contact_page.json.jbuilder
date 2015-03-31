json.browserButtonsSrc image_path('browser-buttons.png')

s3_presigned_post.tap do |presigned_post|
  json.presignedPostHost presigned_post.url.host
  json.presignedPostURL presigned_post.url.to_s
  json.presignedPostFields presigned_post.fields
end

json.business business
json.location business.location.try(:attributes_with_address)
json.openings business.location.openings

json.initialContactBlock (contact_page.contact_block || contact_page.build_contact_block).react_attributes
json.defaultContactBlockAttributes contact_page.default_contact_block_attributes(business)
