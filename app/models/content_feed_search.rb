class ContentFeedSearch
  def initialize(business, unpublished, published, query = '')
    @business = business
    @query = query.to_s.strip
    @unpublished = unpublished
    @published = published
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
    if @unpublished == 'true' && @published != 'true'
      dsl[:filter][:and] << {
        term: {
          published_status: false,
        },
      }
    end

    if @unpublished != 'true' && @published == 'true'
      dsl[:filter][:and] << {
        term: {
          published_status: !false,
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

    @results = Elasticsearch::Model.search('asdcadsc', [BeforeAfter, EventDefinition, Gallery, Offer, Post, QuickPost])

  end
end
