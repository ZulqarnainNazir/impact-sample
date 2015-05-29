class ContentFeedSearch
  def initialize(business, query = '')
    @business = business
    @query = query.to_s.strip
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

    Elasticsearch::Model.search(dsl, [BeforeAfter, EventDefinition, Gallery, Offer, Post, QuickPost])
  end
end
