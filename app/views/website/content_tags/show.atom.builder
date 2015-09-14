posts = posts(@business, content_tag_ids: [@content_tag.id])

atom_feed do |atom|
  atom.title "Tag – #{@content_tag.name}"
  atom.updated posts.first.updated_at if posts.first

  posts.each do |post|
    post_url = case post.class.name
    when 'QuickPost'
      website_quick_post_url(post)
    when 'Event'
      website_event_url(post)
    when 'Gallery'
      website_gallery_url(post)
    when 'BeforeAfter'
      website_before_after_url(post)
    when 'Offer'
      website_offer_url(post)
    when 'Post'
      website_post_url(post)
    end

    atom.entry post, url: post_url do |entry|
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
