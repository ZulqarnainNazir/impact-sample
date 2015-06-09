desc 'Migrate blocks'
task migrate_blocks: [:environment] do
  ActiveRecord::Base.transaction do
    ActiveRecord::Base.connection.execute("UPDATE blocks SET type = 'BlogFeedBlock' WHERE type = 'FeedBlock'")
    ActiveRecord::Base.connection.execute("UPDATE blocks SET type = 'SidebarBlogFeedBlock' WHERE type = 'SidebarFeedBlock'")
    ActiveRecord::Base.connection.execute("UPDATE blocks SET type = 'SidebarEventsFeedBlock' WHERE type = 'SidebarEventsBlock'")

    AboutPage.find_each do |about_page|
      about_block = AboutBlock.where(frame_type: 'Webpage', frame_id: about_page.id).first
      team_block = TeamBlock.where(frame_type: 'Webpage', frame_id: about_page.id).first

      if about_block
        about_group = about_page.groups.new(type: 'AboutGroup')
        about_group.blocks = [about_block]
        about_block.position = 0
        about_group.save!
        about_block.save!
      end

      if team_block
        team_group = about_page.groups.new(type: 'TeamGroup')
        team_group.blocks = [team_block]
        team_block.position = 0
        team_group.save!
        team_block.save!
      end
    end

    ContactPage.find_each do |contact_page|
      contact_block = ContactBlock.where(frame_type: 'Webpage', frame_id: contact_page.id).first_or_initialize

      if contact_block
        contact_group = contact_page.groups.new(type: 'ContactGroup')
        contact_group.blocks = [contact_block]
        contact_block.position = 0
        contact_group.save!
        contact_block.save!
      end
    end

    BlogPage.find_each do |blog_page|
      blog_feed_block = BlogFeedBlock.where(frame_type: 'Webpage', frame_id: blog_page.id).first_or_initialize
      sidebar_blog_feed_block = SidebarBlogFeedBlock.where(frame_type: 'Webpage', frame_id: blog_page.id).first
      sidebar_content_blocks = SidebarContentBlock.where(frame_type: 'Webpage', frame_id: blog_page.id).all

      if blog_feed_block
        blog_feed_group = blog_page.groups.new(type: 'BlogFeedGroup')
        blog_feed_group.blocks = [blog_feed_block]
        blog_feed_block.position = 0
        blog_feed_group.save!
        blog_feed_block.save!
      end

      if sidebar_blog_feed_block || sidebar_content_blocks.any?
        sidebar_group = blog_page.groups.new(type: 'SidebarGroup')
        sidebar_group.blocks = [sidebar_blog_feed_block, *sidebar_content_blocks].compact.each_with_index.map { |b, i| b.position = i; b }
        sidebar_group.save!
        sidebar_blog_feed_block.save!
        sidebar_content_blocks.each(&:save!)
      end
    end

    Webpage.where(type: %w[CustomPage HomePage]).find_each do |webpage|
      blog_feed_block = BlogFeedBlock.where(frame_type: 'Webpage', frame_id: webpage.id).first
      call_to_action_blocks = CallToActionBlock.where(frame_type: 'Webpage', frame_id: webpage.id).all
      content_blocks = ContentBlock.where(frame_type: 'Webpage', frame_id: webpage.id).all
      hero_block = HeroBlock.where(frame_type: 'Webpage', frame_id: webpage.id).first
      sidebar_blog_feed_block = SidebarBlogFeedBlock.where(frame_type: 'Webpage', frame_id: webpage.id).first
      sidebar_content_blocks = SidebarContentBlock.where(frame_type: 'Webpage', frame_id: webpage.id).all
      sidebar_events_feed_block = SidebarEventsFeedBlock.where(frame_type: 'Webpage', frame_id: webpage.id).first
      specialty_blocks = SpecialtyBlock.where(frame_type: 'Webpage', frame_id: webpage.id).all
      tagline_blocks = TaglineBlock.where(frame_type: 'Webpage', frame_id: webpage.id).all

      order = webpage.settings.try(:[], :block_type_order).to_s.split(',')
      %w[hero tagline call_to_action specialty content feed interior].each do |type|
        order << type unless order.include?(type)
      end

      if blog_feed_block
        blog_feed_group = webpage.groups.new(type: 'BlogFeedGroup')
        blog_feed_group.blocks = [blog_feed_block]
        blog_feed_block.position = 0
        blog_feed_group.position = order.index('feed')
        blog_feed_group.save!
        blog_feed_block.save!
      end

      if call_to_action_blocks.any?
        call_to_action_group = webpage.groups.new(type: 'CallToActionGroup')
        call_to_action_group.blocks = call_to_action_blocks.each_with_index.map { |b, i| b.position = i; b }
        call_to_action_group.position = order.index('call_to_action')
        call_to_action_group.save!
        call_to_action_blocks.each(&:save!)
      end

      if content_blocks.any?
        content_group = webpage.groups.new(type: 'ContentGroup')
        content_group.blocks = content_blocks.each_with_index.map { |b, i| b.position = i; b }
        content_group.position = order.index('content')
        content_group.save!
        content_blocks.each(&:save!)
      end

      if hero_block
        hero_group = webpage.groups.new(type: 'HeroGroup')
        hero_group.blocks = [hero_block]
        hero_block.position = 0
        hero_group.position = order.index('hero')
        hero_group.save!
        hero_block.save!
      end

      if sidebar_blog_feed_block || sidebar_events_feed_block || sidebar_content_blocks.any?
        sidebar_group = webpage.groups.new(type: 'SidebarGroup')
        sidebar_group.blocks = [sidebar_blog_feed_block, sidebar_events_feed_block, *sidebar_content_blocks].compact.each_with_index.map { |b, i| b.position = i; b }
        sidebar_group.position = 1
        sidebar_group.save!
        sidebar_blog_feed_block.save! if sidebar_blog_feed_block
        sidebar_events_feed_block.save! if sidebar_events_feed_block
        sidebar_content_blocks.each(&:save!)
      end

      if specialty_blocks.any?
        specialty_group = webpage.groups.new(type: 'SpecialtyGroup')
        specialty_group.blocks = specialty_blocks.each_with_index.map { |b, i| b.position = i; b }
        specialty_group.position = order.index('specialty')
        specialty_group.save!
        specialty_blocks.each(&:save!)
      end

      if tagline_blocks.any?
        tagline_group = webpage.groups.new(type: 'TaglineGroup')
        tagline_group.blocks = tagline_blocks.each_with_index.map { |b, i| b.position = i; b }
        tagline_group.position = order.index('tagline')
        tagline_group.save!
        tagline_blocks.each(&:save!)
      end
    end
  end
end
