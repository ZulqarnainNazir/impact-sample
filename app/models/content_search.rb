class ContentSearch
  def initialize(business, models: [BeforeAfter, Event, Gallery, Offer, Post, QuickPost], query: '', strict: true)
    @business = business
    @query = query.to_s.strip
    @models = models
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
              field: :occurs_on,
            },
          },
          {
            range: {
              occurs_on: {
                gte: Time.zone.now,
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
      dsl[:sort] = {
        sorting_date: :desc,
      }
    end

    Elasticsearch::Model.search(dsl, @models)
  end
end
