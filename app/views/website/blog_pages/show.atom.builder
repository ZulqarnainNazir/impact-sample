blog_feed_group = @page.groups.where(type: 'BlogFeedGroup').first
blog_feed_block = blog_feed_group.blocks.where(type: 'BlogFeedBlock').first if blog_feed_group
blog_feed_posts = get_content(blog_feed_block.business, blog_feed_block, '', '', blog_feed_block.content_category_ids.to_s.split(' ').map(&:to_i), blog_feed_block.content_tag_ids.to_s.split(' ').map(&:to_i), 'desc', '', blog_feed_block.items_limit) if blog_feed_block

if blog_feed_group && blog_feed_block
  atom_feed do |atom|
    atom.title @page.title
    atom.updated blog_feed_posts.first.updated_at if blog_feed_posts.first

    blog_feed_posts.each do |post|
      atom.entry post, url: website_generic_post_url(post.to_generic_param) do |entry|
        entry.title post.title, type: 'html'

        post.content_categories.each do |category|
          entry.category term: category.name, label: category.name, scheme: website_content_category_url(category)
        end

        post.content_tags.each do |tag|
          entry.category term: tag.name, scheme: website_content_tag_url(tag)
        end

        case post.class.name
        when 'QuickPost'
          entry.content truncate(sanitize(post.content), length: 250)
        when 'Event'
          entry.content truncate(sanitize(post.event_definition.description), length: 250)
        when 'Gallery'
          entry.content truncate(sanitize(post.description), length: 250)
        when 'BeforeAfter'
          entry.content truncate(sanitize(post.description), length: 250)
        when 'Offer'
          entry.content truncate(sanitize(post.offer), length: 250) + truncate(sanitize(post.description), length: 250)
        when 'Post'
          entry.content truncate(sanitize(post.sections_content), length: 250)
        end
      end
    end
  end
end
