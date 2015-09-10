class ContentBlogSearch
  def initialize(business, query = '', content_category_ids: [], content_tag_ids: [])
    @business = business
    @query = query.to_s.strip
    @content_category_ids = content_category_ids
    @content_tag_ids = content_tag_ids
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
          {
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
          },
          {
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
          },
          {
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
          },
        ],
      },
    }

    if @content_category_ids.any?
      dsl[:filter][:and] << {
        terms: {
          content_category_ids: @content_category_ids,
        },
      }
    end

    if @content_tag_ids.any?
      dsl[:filter][:and] << {
        terms: {
          content_tag_ids: @content_tag_ids,
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
        sorting_date: :desc,
      }
    end

    Elasticsearch::Model.search(dsl, [BeforeAfter, Event, Gallery, Offer, Post, QuickPost])
  end
end
