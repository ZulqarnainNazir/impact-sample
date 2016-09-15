module ContentHelper
    def title(string_or_locals = {})
        content_for :title, string_or_locals if string_or_locals.is_a? String
    end

    def description(string_or_locals = {})
        content_for :description, string_or_locals if string_or_locals.is_a? String
    end

    def image(url)
        content_for :image, url
    end

    def errors_for(resource, message: nil)
        if resource && resource.errors.full_messages.any?
            render partial: 'errors', locals: { message: message, error_messages: resource.errors.full_messages.uniq }
        end
    end

    def canonical_url(string_or_locals = {})
        if string_or_locals.is_a? String
            content_for :canonical_url, string_or_locals
        end
    end

    def canonize_string(string_or_locals = {})
        content_for :canonical_url, string_or_locals
    end

    def canonize_obj(post_vars = {})
        # get the url from @post.generic_param, without railsy query string for resources
        # binding.pry
        url = post_vars[:url]
        # binding.pry
        ind = url.index('/posts/') || url.index('/offers/') || url.index('/events/') || url.index('/quick_posts') || url.index('/galleries')
        # binding.pry
        base = post_vars[:url][0..ind]
        # binding.pry
        content_for :canonical_url, base + "#{post_vars[:params][:year]}/#{post_vars[:params][:month]}/#{post_vars[:params][:day]}/#{post_vars[:params][:id]}/#{post_vars[:params][:slug]}"
        # binding.pry
    end

    def canonize_nested_resource(parent, child)
      # binding.pry
      canonize_obj({url: website_gallery_url, params: parent.to_generic_param})
      if child.gallery_image.title
        content_for :canonical_url, "/#{child.id}/#{child.gallery_image.title.parameterize}"
      end
      content_for :canonical_url
    end


    def has_footer_embed(website, page)
      if website.footer_embed
        is_blog = (page.class == BlogPage) || (defined? @quick_post)
        is_landing_page = page.respond_to?(:hide_navigation) && page.hide_navigation == '1'
        if (is_blog && website.embed_on_blog) || (is_landing_page && website.embed_on_landing)
          return false
        elsif is_blog || is_landing_page
          return true
        else
          return true
        end
      end
    end
end
