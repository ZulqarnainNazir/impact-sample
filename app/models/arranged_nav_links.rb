class ArrangedNavLinks
  def new(links)
    @links = links
  end

  def arrange
    @links.each do |link|
      link.index = (SecureRandom.random_number*10**10).to_i if link.index.blank?
      link.key = SecureRandom.uuid if link.key.blank?
    end

    @links.each do |link|
      if link.parent_key.blank?
        parent = @links.find { |l| l.persisted? && l.id == link.parent_id }
        link.parent_key = parent.key if parent
      end
    end

    roots = @links.select do |link|
      link.parent_key.blank?
    end

    arrange_children(roots)
  end

  private

  def arrange_children(parents)
    parents.map do |link|
      children = @links.select do |s|
        s.parent_key == link.key
      end
      link.cached_children = arrange_children(children)
      link
    end.sort do |a, b|
      a.position.to_i <=> b.position.to_i
    end
  end
end
