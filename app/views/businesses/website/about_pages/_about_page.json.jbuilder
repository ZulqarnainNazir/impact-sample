json.browserButtonsSrc image_path('browser-buttons.png')

s3_presigned_post.tap do |presigned_post|
  json.presignedPostHost presigned_post.url.host
  json.presignedPostURL presigned_post.url.to_s
  json.presignedPostFields presigned_post.fields
end

json.teamMembers business.team_members.map(&:attributes_with_profile_and_name)
json.teamMembersPath business_data_team_members_path(business)

json.initialAboutBlock about_page.about_block.try(:react_attributes)
json.defaultAboutBlockAttributes about_page.default_about_block_attributes(business)

if business.team_members.any?
  json.initialTeamBlock (about_page.team_block || about_page.build_team_block).react_attributes
else
  json.initialTeamBlock about_page.team_block.try(:react_attributes)
end
