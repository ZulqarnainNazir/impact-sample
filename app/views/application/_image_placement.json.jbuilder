s3_presigned_post.tap do |presigned_post|
  json.presignedPostHost presigned_post.url.host
  json.presignedPostURL presigned_post.url.to_s
  json.presignedPostFields presigned_post.fields
end

json.label 'Logo Image'
json.inputPrefix label
json.imagesPath business_images_path(business)

json.initialPlacementID = model.placement_id
json.initialPlacementDestroy = model.placement_destroy
json.initialImageID = model.image_id
json.initialImageURL = model.image_url
json.initialImageAlt = model.image_alt
json.initialImageTitle = model.image_title
json.initialImageContentType = model.image_content_type
json.initialImageFileName = model.image_file_name
json.initialImageFileSize = model.image_file_size
