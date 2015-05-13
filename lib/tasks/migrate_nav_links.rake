desc "Migrate header and footer menu data to NavLink objects"
task migrate_nav_links: [:environment] do
  ActiveRecord::Base.transaction do
    Website.find_each do |website|
      header = Array(website.header_menu).map(&:with_indifferent_access)
      footer = Array(website.footer_menu).map(&:with_indifferent_access)
      
      header.each do |item|
        item[:webpage_id] = item.delete(:id)
        item[:key] = SecureRandom.uuid
      end

      header.each do |item|
        parent_id = item.delete(:parent_id)

        if parent_id
          parent = header.find { |i| i[:webpage_id] == item[:parent_id] }

          if parent
            item[:parent_key] = parent[:key]
          end
        end
      end

      header_attributes = header.map do |item|
        attributes = nil
        webpage = Webpage.find_by_id(item[:webpage_id])
        children = header.select { |i| i[:parent_key] == item[:key] }

        if webpage
          attributes = {
            key: item[:key],
            parent_key: item[:parent_key],
            location: 'header',
            label: webpage.name,
          }

          if item[:parent_key].blank? || children.empty?
            attributes.merge!(kind: 'internal', webpage_id: webpage.id)
          else
            attributes.merge!(kind: 'dropdown')
          end
        end

        attributes
      end.compact

      footer_attributes = footer.map do |item|
        attributes = nil
        webpage = Webpage.find_by_id(item[:webpage_id])

        if webpage
          {
            location: 'footer',
            kind: 'internal',
            label: webpage.name,
            webpage_id: webpage.id,
          }
        end
      end.compact

      website.update!(nav_links_attributes: header_attributes + footer_attributes)

      website.nav_links.each do |nav_link|
        parent_id = nil

        if nav_link.parent_key.present?
          parent_id = website.nav_links.select do |link|
            link.key == nav_link.parent_key
          end
        end

        nav_link.update! parent_id: parent_id
      end
    end
  end
end
