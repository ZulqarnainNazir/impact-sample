# rake migrate_blog_feed_blocks_to_cotent_feed_widgets
# DELETE: ContentFeedWidget.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).delete_all

desc 'Migrate Blog Feed Blocks to Content Feed Widgets'
task migrate_blog_feed_blocks_to_cotent_feed_widgets: [:environment] do



BlogFeedBlock.all.each_with_index do |block, i|

  puts "Processing #{i} - #{block&.business&.id}"

  #TODO - Replace feed settings in webbulder with dropdown for content feed widget selector
  #TODO - How to handle Link, paginate part of web builder? Override?

  widget = ContentFeedWidget.create(
    business_id: block&.business&.id,
    name: "#{block&.business&.name} #{block.type.underscore.humanize.titlecase} #{i}" || "Content Feed - #{i}",
    max_items: block.settings['items_limit'],
    link_label: block.link_label,
    enable_search: block.settings['include_search'],
    content_types: block.settings['content_types'],
    company_list_ids: block.settings['company_list_ids'],
    show_our_content: block.show_our_content,
    link_id: block.link_id,
    link_external_url: block.link_external_url,
    link_target_blank: block.link_target_blank,
    link_no_follow: block.link_no_follow,
    link_version: block.link_version
  )

  # Missing from create: UUID (auto generate?), Status (what does this do?), public_name (excluded by design)

  # Link webbulder block to new feed
  block.widget_id = widget.id
  block.save!



end

# Existing Format
# BlogFeedGroup.find(9994).blocks
#
# => [#<BlogFeedBlock:0x00007fbffdcabb78
#   id: 16014,
#   frame_id: 9994,
#   frame_type: "Group",
#   link_id: nil,
#   link_type: "Webpage",
#   type: "BlogFeedBlock",
#   type: "BlogFeedBlock",
#   theme: "default",
#   style: "",
#   link_label: "View More",
#   heading: "<br>",
#   subheading: "<br>",
#   text: "<br>",
#   link_external_url: "http://",
#   link_target_blank: false,
#   link_no_follow: false,
#   link_version: 3,
#   spoof: nil,
#   settings:
#    {"background_color"=>"",
#     "foreground_color"=>"",
#     "link_color"=>"",
#     "height"=>0,
#     "items_limit"=>"12",
#     "well_style"=>"",
#     "custom_class"=>"",
#     "custom_anchor_id"=>"",
#     "content_types"=>"QuickPost Event Gallery BeforeAfter Offer CustomPost PaidJob VolunteerJob",
#     "content_category_ids"=>"110",
#     "company_list_ids"=>"",
#     "content_tag_ids"=>"",
#     "widget_id"=>"",
#     "contact_form_widget_id"=>"",
#     "include_search"=>"",
#     "background_aspect_ratio"=>"NaN"},
#   created_at: Thu, 12 Jul 2018 22:10:01 UTC +00:00,
#   updated_at: Sun, 14 Jul 2019 00:05:35 UTC +00:00,
#   layout: "",
#   position: 0,
#   show_our_content: true>]


# New Format
# ContentFeedWidget.find(42)
#
# => #<ContentFeedWidget:0x00007fbff37c4088
#  id: 42,
#  name: "Content Feed from Communities",
#  public_label: "",
#  uuid: "1bc44520-f012-47b1-af29-a5d606af4c5d",
#  business_id: 247,
#  max_items: 12,
#  link_label: "View More",
#  enable_search: true,
#  content_types: ["QuickPost", "BeforeAfter", "Offer", "CustomPost", ""],
#  created_at: Wed, 19 Sep 2018 02:34:13 UTC +00:00,
#  updated_at: Wed, 19 Sep 2018 02:34:13 UTC +00:00,
#  company_list_ids: ["", "471", "505", "508"],
#  show_our_content: false,
#  status: nil>


end
