class FacebookAnalytics

  attr_accessor :graph, :business

  def initialize(args)
    @graph = Koala::Facebook::API.new(args[:facebook_token])
    @business = args[:business]
  end
 
  def build_query_from_params(args)
    query = ""
    args.each do |param , value|
      query << "?#{param}=#{value}"
   end
   query
  end

  def get_page_insights(page_id, metric, args)
    graph.get_object("#{page_id}/insights/#{metric}" << build_query_from_params(args))
  end

  def get_total_post_comment_count(post_id)
    graph.get_object("#{post_id}/comments").count
  end   

  def get_total_post_like_count(post_id)
    graph.get_object("#{post_id}/likes").count
  end

  def get_total_post_click_count(post_id)
    graph.get_object("#{post_id}", metric: 'post_engaged_users').count
  end

  def get_total_post_reach_count(post_id)
    graph.get_object("#{post_id}", metric: 'post_reach').count
  end 
end
