module OfferSearchConcern
  extend ActiveSupport::Concern

  def search_event(widget, business, query = '', content_category_ids = [], content_tag_ids = [], include_past = false)

    #TODO: Need to make widget an option field. It isn't needed in directory content since that content will only be from that business. So business could be the business of the widget for purposes of including own content (which can be done with Widget.business_id) or could be just a target business

    if @widget

      @widget = widget
      @business_ids = @widget.get_business_ids #business_ids should be an array; returns array of Business ids, or empty array
      if @widget.show_our_content == true
        @business_ids << @widget.business_id #includes parent business' content
      end
    else
      @business_ids = business.id
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

    dsl1[:filter][:and] << {
      term: {
        published_status: true,
      },
    }

    # if !@include_past
    #   dsl1[:filter][:and] << {
    #     or: [
    #       {
    #         missing: {
    #           field: :occurs_on,
    #         },
    #       },
    #       {
    #         range: {
    #           occurs_on: {
    #             gte: Time.zone.now,
    #           },
    #         },
    #       },
    #     ],
    #   }
    # end

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
        published_at: :desc,
      }
    end

    Elasticsearch::Model.search(dsl1, [Offer]).records.to_a

  end
end
