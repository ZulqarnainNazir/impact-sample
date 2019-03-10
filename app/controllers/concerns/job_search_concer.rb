module JobSearchConcern
  extend ActiveSupport::Concern

  def search_event(widget, business, query = '', content_category_ids = [], content_tag_ids = [], include_past = false)

    @widget = widget
    @business = business
    @business_ids = @widget.get_business_ids #business_ids should be an array; returns array of Business ids, or empty array
    if @widget.show_our_content == true
      @business_ids << @business.id #includes parent business' content
    end
    @query = query.to_s.strip
    # @content_types = content_types
    @content_category_ids = content_category_ids
    @content_tag_ids = content_tag_ids
    @include_past = include_past


    dsl1 = {
      size: 800,

      filter: {
        and: [
          {
            terms: {
              business_id: @business_ids,
            },
          },
          # {
          #   or: [
          #     {
          #       missing: {
          #         field: :published_on,
          #       },
          #     },
          #     {
          #       range: {
          #         published_on: {
          #           lte: Time.zone.now,
          #         },
          #       },
          #     },
          #   ],
          # },
          # {
          #   or: [
          #     {
          #       missing: {
          #         field: :valid_until,
          #       },
          #     },
          #     {
          #       range: {
          #         valid_until: {
          #           gte: Time.zone.now,
          #         },
          #       },
          #     },
          #   ],
          # },
        ],
      },
    }

    dsl1[:filter][:and] << {
      term: {
        published_status: true,
      },
    }

    dsl1[:filter][:and] << {
      term: {
        import_pending: false,
      },
    }

    if !@include_past
      dsl1[:filter][:and] << {
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
      }
    end

    if @content_category_ids.present?
      dsl1[:filter][:and] << {
        terms: {
          content_category_ids: @content_category_ids,
        },
      }
    end

    if @content_tag_ids.present?
      dsl1[:filter][:and] << {
        terms: {
          content_tag_ids: @content_tag_ids,
        },
      }
    end

    if @query.present?
      dsl1[:query] = {
        query_string: {
          fields: %w[title^2 subtitle description],
          # query: "#{@query}~", #tilde is for fuzzy searches
          query: @query,
        }
      }
    else
      dsl1[:sort] = {
        sorting_date: :desc,
      }
    end

    Elasticsearch::Model.search(dsl1, [EventDefinition]).records.to_a

  end
end
