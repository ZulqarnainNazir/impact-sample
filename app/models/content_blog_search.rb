class ContentBlogSearch
  def initialize(business, query = '', content_types: [], content_category_ids: [], content_tag_ids: [])
    @business = business
    @query = query.to_s.strip
    @content_types = content_types
    @content_category_ids = content_category_ids
    @content_tag_ids = content_tag_ids
  end

  def search
    dsl = {

      query: {
          term: {
            published_status: true
          }
      },

      filter: {
        and: [
          {
            term: {
              business_id: @business.id,
            },
          },
          # {
          #     term: {
          #         published_status: true,
          #     },
          # },
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
          fields: %w[title^2 description],
          query: "#{@query}~",
        },
      }
    else
      dsl[:sort] = {
        sorting_date: :desc,
      }
    end

    if @content_types.present? && @content_types.any?
      content_classes = []

      @content_types.each do |type|
        if %w[QuickPost Event Gallery BeforeAfter Offer Post].include?(type)
          content_classes << type.constantize
        end
        content_classes << Post if type == 'CustomPost'
      end
      if content_classes.include?(Event)
        # content_classes.delete(Event)
        content_classes << EventDefinition
      end
    else
      content_classes = [QuickPost, EventDefinition, Gallery, BeforeAfter, Offer, Post]
    end

    Elasticsearch::Model.search(dsl, content_classes)
  end
end
