module SearchHelper

  #Need to see whereelse this is used beside feed blocks....looks like its used for events too???
  def get_content_types(group_type, page_instance_variable)
    if defined?(page_instance_variable.content_types) || page_instance_variable.groups.where(type: group_type).first.try(:blocks)
      if defined?(page_instance_variable.content_types)
        @content_types_all = page_instance_variable.content_types.join(" ")
      else
        @content_types_all = page_instance_variable.groups.where(type: group_type).first.blocks.first.content_types
      end
      if @content_types_all.nil? || @content_types_all.empty? # ||....<=checks to see if "", empty string, is in db, signifying "show all content types"
        @content_types_all = "QuickPost Gallery BeforeAfter Offer Post Job"
      end
      if @content_types_all.present?
        @content_types_all = @content_types_all.split
      end
    end
    if !params[:content_types].present? && !@content_types_all.nil?
      params[:content_types] = @content_types_all
    elsif params[:content_types].present?
      @content_types = params[:content_types]
    end
    if @content_types_all.present?
      prune_content_types_all(@content_types_all)
    end
  end

  def prune_content_types_all(content_types_all)



    #ElasticSearch will search for 'CustomPost' and 'QuickPost' via just 'Post'
    # if @content_types_all.include?('CustomPost') || @content_types_all.include?('QuickPost')
    if @content_types_all.include?('CustomPost')
      @content_types_all.delete('CustomPost')
      # @content_types_all.delete('QuickPost')
      @content_types_all << 'Post'
    end

  end

end
