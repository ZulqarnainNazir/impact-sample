posts = posts(@business, content_category_ids: [@content_category.id])

xml.instruct! :xml, version: '1.0', encoding: 'UTF-8'
xml.rss version: '2.0', 'xmlns:media' => 'http://search.yahoo.com/mrss/', 'xmlns:atom' => 'http://www.w3.org/2005/Atom' do
  xml.channel do
    xml.title "Category – #{@content_category.name}"
    xml.link website_content_category_url(@content_category)
    xml.atom :link, href: website_content_category_url(@content_category), rel: 'self', type: 'application/rss+xml'
    xml.language 'en-US'
    xml.ttl '40'

    posts.each do |post|
      xml.item do
        xml.title { |x| x.cdata! post.title }
        xml.pubDate post.respond_to?(:published_at) ? post.published_at.rfc822 : post.created_at.rfc822

        xml.description() do |x|
          case post.class.name
          when 'QuickPost'
            x.cdata! truncate(sanitize(post.content), length: 250)
          when 'Event'
            x.cdata! truncate(sanitize(post.event_definition.description), length: 250)
          when 'Gallery'
            x.cdata! truncate(sanitize(post.description), length: 250)
          when 'BeforeAfter'
            x.cdata! truncate(sanitize(post.description), length: 250)
          when 'Offer'
            x.cdata! truncate(sanitize(post.offer), length: 250) + truncate(sanitize(post.description), length: 250)
          when 'Post'
            x.cdata! truncate(sanitize(post.sections_content), length: 250)
          end
        end

        post.content_categories.each do |category|
          xml.category category.name
        end

        post.content_tags.each do |tag|
          xml.category tag.name
        end

        case post.class.name
        when 'QuickPost'
          xml.media :content, url: post.quick_post_image.try(:attachment_url)
        when 'Event'
          xml.media :content, url: post.main_image.try(:attachment_url) || post.event_definition.try(:event_image_placement).try(:attachment_url)
        when 'Gallery'
          xml.media :content, url: post.main_image.try(:attachment_url) || post.gallery_images.first.try(:gallery_image).try(:attachment_url)
        when 'BeforeAfter'
          xml.media :content, url: post.main_image.try(:attachment_url) || post.before_image.try(:attachment_url) || post.after_image.try(:attachment_url)
        when 'Offer'
          xml.media :content, url: post.main_image.try(:attachment_url) || post.offer_image.try(:attachment_url)
        when 'Post'
          xml.media :content, url: post.main_image.try(:attachment_url) || post.post_sections.find { |ps| ps.post_section_image }.try(:post_section_image).try(:attachment_url)
        end

        case post.class.name
        when 'QuickPost'
          xml.link website_quick_post_url(post)
        when 'Event'
          xml.link website_event_url(post)
        when 'Gallery'
          xml.link website_gallery_url(post)
        when 'BeforeAfter'
          xml.link website_before_after_url(post)
        when 'Offer'
          xml.link website_offer_url(post)
        when 'Post'
          xml.link website_post_url(post)
        end
      end
    end
  end
end
