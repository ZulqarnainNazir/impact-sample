class ContentFeedSearch
  def initialize(business, query = '', filters)
    @business = business
    @query = query.to_s.strip
    @filters = filters
  end

  def search
    dsl = {
      filter: {
        and: [
          {
            term: {
              business_id: @business.id,
            },
          },
        ],
      },
    }

    if @query.present?
      dsl[:query] = {
        query_string: {
          query: @query,
          fields: %w[title^2 description],
        },
      }
    else
      dsl[:sort] = {
        created_at: :desc,
      }
    end
    binding.pry
    @results = Elasticsearch::Model.search(dsl, [BeforeAfter, EventDefinition, Gallery, Offer, Post, QuickPost])
    binding.pry
    if @filters[:drafts] and ! @filters[:published]
      binding.pry
      @results.results.reject { |rec| rec['_source']['published_status'] == false }
      binding.pry
    elsif @filters[:drafts] and ! @filters[:published]
      binding.pry
      @results.results = @results.results.reject { |rec| rec['_source']['published_status'] == (true || nil) }
      binding.pry
    end
    binding.pry
    binding.pry
    @results
    binding.pry
  end
end
