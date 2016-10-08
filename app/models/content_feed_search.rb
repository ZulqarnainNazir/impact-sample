class ContentFeedSearch
  def initialize(business, unpublished, query = '')
    @business = business
    @query = query.to_s.strip
    @unpublished = unpublished
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

    if @unpublished == 'false'
      dsl[:filter][:and] << {
        term: {
          published_status: false,
        },
      }
    end

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
