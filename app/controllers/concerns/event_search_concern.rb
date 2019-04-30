module EventSearchConcern
  extend ActiveSupport::Concern

  # TODO - Originally search_event. Need to find places in master branch that need to be updated after merge inlucding new fields / field order
  # Finds events for a given business for display in widget, web builder or listings
  def get_events(business: nil, embed: nil, query: nil, kinds: [], content_category_ids: [], content_tag_ids: [], filter: 'All', order: 'desc', page: 1, per_page: 10, include_past: false, include_drafts: false, start_date: nil, end_date: nil, limit: false)
    raise "Business is Required" unless business.present?

    #TODO - Add a filter for defined categories from a local network
    #TODO - Add filter for defined sources from feeds
    #TODO - Need to renable KINDS

    # Initialize
    @business = business
    @embed = embed
    @query = query.to_s.strip
    @kinds = kinds
    @content_category_ids = content_category_ids
    @content_tag_ids = content_tag_ids
    @filter = filter
    @order = order
    @page_no = page
    @per_page = per_page
    @include_past = include_past
    @start_date = start_date
    @end_date = end_date
    @limit = limit

    # Apply Business Logic
    @business_ids = []
    if @embed.present?
      @business_ids = @embed.get_business_ids #business_ids should be an array; returns array of Business ids, or empty array

      if @embed.show_our_content == true
        @business_ids << @business.id #includes parent business' content
      end
    else
      @business_ids << @business.id
    end

    # Perfom Elsticsearch query
    dsl1 = {
      size: 800,

      filter: {
        and: [
          {
            terms: {
              business_id: @business_ids,
            },
          },
        ],
      },
    }

    dsl1[:filter][:and] << {
      term: {
        import_pending: false,
      },
    }

    # TODO - Combine DRAFTS, PUBLISHED into one field where Published = True, Published = false, Published = '' (all) and update controller to call based on params
    if @filter == "Drafts"

      dsl1[:filter][:and] << {
        term: {
          published_status: false,
        },
      }

    end

    if !@include_drafts || @filter == "Published"
      dsl1[:filter][:and] << {
        term: {
          published_status: true,
        },
      }
    end

    if !@include_past && (!@start_date.present? || !@end_date.present?)
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

    if @start_date.present?
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
                gte: @start_date,
              },
            },
          },
        ],
      }

    end

    if @end_date.present?
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
                lte: @end_date,
              },
            },
          },
        ],
      }

    end

    if @limit
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
                lte: Time.zone.now + 12.months,
              },
            },
          },
        ],
      }
    end

    if @kinds.present?
      dsl1[:filter][:and] << {
        terms: {
          kind: @kinds,
        },
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
        # sorting_date: @order,
        occurs_on: @order,
      }
    end

    # TODO - This should be Event and includes(:event_definition)
    @all_events = Elasticsearch::Model.search(dsl1, [Event]).records.to_a
    # @all_events = Elasticsearch::Model.search(dsl1, [EventDefinition]).includes(:event_definitions).records.to_a
    # @all_events = Event.search(dsl1).records.includes(:event_definitions).to_a

    #Sort and return content object
    Kaminari.paginate_array(@all_events).page(@page_no).per(@per_page)

  end
end
