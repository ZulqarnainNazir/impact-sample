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
    @results = Elasticsearch::Model.search(dsl, [BeforeAfter, EventDefinition, Gallery, Offer, Post, QuickPost])

  end
end
