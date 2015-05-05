class ContentSearch
  def initialize(business, query = '*', strict: true)
    @business = business
    @query = query.to_s.strip
    @strict = strict
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

    if @strict
      dsl[:filter][:and].push({
        or: [
          {
            missing: {
              field: :valid_until,
            },
          },
          {
            range: {
              valid_until: {
                gte: Time.zone.now,
              },
            },
          },
        ],
      })
      dsl[:filter][:and].push({
        or: [
          {
            missing: {
              field: :published_on,
            },
          },
          {
            range: {
              published_on: {
                lte: Time.zone.now,
              },
            },
          },
        ],
      })
    end

    if @query.present?
      dsl[:query] = {
        query_string: {
          query: @query,
          fields: %w[title^2 description],
        },
      }
    else
      #dsl[:sort] = {
        #_script: {
          #script: 'if (_source["published_on"] == null) { doc["created_at"].value } else { doc["published_on"].value }',
          #type: :number,
          #order: :desc,
        #},
      #}
    end

    Elasticsearch::Model.search(dsl, [BeforeAfter, Gallery, Offer, Post])
  end
end
