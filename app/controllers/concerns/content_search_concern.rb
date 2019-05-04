module ContentSearchConcern
  extend ActiveSupport::Concern

  # Finds content for a given business for display in widget, web builder or listings
  # publised can have 3 values true, false or nil where nil = all, defulat is true
  def get_content(business: nil, embed: nil, query: nil, content_types: ["QuickPost", "Gallery", "BeforeAfter", "Offer", "Job" ,"Post"], content_category_ids: [], content_tag_ids: [], order: "desc", page: 1, per_page: 10, published: true)
    raise "Business is Required" unless business.present?

    # Initialize
    query = query.to_s.strip

    # Apply Business Logic
    business_ids = []
    if embed.present?
      business_ids = embed.get_business_ids #business_ids should be an array; returns array of Business ids, or empty array

      if embed.show_our_content == true
        business_ids << business.id #includes parent business' content
      end
    else
      business_ids << business.id
    end

    # Perfom Elsticsearch queries
    all_content = []
    content_types.each do |type|
      case type
      when 'QuickPost'
        all_content += search_quick_posts(business_ids, content_category_ids, content_tag_ids, query, order, published)
      when 'Post'
        all_content += search_posts(business_ids, content_category_ids, content_tag_ids, query, order, published)
      when 'Offer'
        all_content += search_offers(business_ids, content_category_ids, content_tag_ids, query, order, published)
      when 'Job'
        all_content += search_jobs(business_ids, content_category_ids, content_tag_ids, query, order, published)
      when 'Gallery'
        all_content += search_galleries(business_ids, content_category_ids, content_tag_ids, query, order, published)
      when 'BeforeAfter'
        all_content += search_before_afters(business_ids, content_category_ids, content_tag_ids, query, order, published)
      end
    end

    #Sort and return content objects
    Kaminari.paginate_array(all_content.sort_by {|obj| obj.published_at}.reverse!).page(page).per(per_page)

    # # Initialize
    # @business = business
    # @embed = embed
    # @query = query.to_s.strip
    # @content_types = content_types
    # @content_category_ids = content_category_ids
    # @content_tag_ids = content_tag_ids
    # @order = order
    # @page_no = page
    # @per_page = per_page
    # @published = published
    #
    # # Apply Business Logic
    # @business_ids = []
    # if @embed.present?
    #   @business_ids = @embed.get_business_ids #business_ids should be an array; returns array of Business ids, or empty array
    #
    #   if @embed.show_our_content == true
    #     @business_ids << @business.id #includes parent business' content
    #   end
    # else
    #   @business_ids << @business.id
    # end
    #
    # # Perfom Elsticsearch queries
    # @all_content = []
    # @content_types.each do |type|
    #   case type
    #   when 'QuickPost'
    #     @all_content += search_quick_posts(@business_ids, @content_category_ids, @content_tag_ids, @query, @order, @published)
    #   when 'Post'
    #     @all_content += search_posts(@business_ids, @content_category_ids, @content_tag_ids, @query, @order, @published)
    #   when 'Offer'
    #     @all_content += search_offers(@business_ids, @content_category_ids, @content_tag_ids, @query, @order, @published)
    #   when 'Job'
    #     @all_content += search_jobs(@business_ids, @content_category_ids, @content_tag_ids, @query, @order, @published)
    #   when 'Gallery'
    #     @all_content += search_galleries(@business_ids, @content_category_ids, @content_tag_ids, @query, @order, @published)
    #   when 'BeforeAfter'
    #     @all_content += search_before_afters(@business_ids, @content_category_ids, @content_tag_ids, @query, @order, @published)
    #   end
    # end
    #
    # #Sort and return content objects
    # Kaminari.paginate_array(@all_content.sort_by {|obj| obj.published_at}.reverse!).page(@page_no).per(@per_page)

  end

  def search_quick_posts(business_ids, content_category_ids, content_tag_ids, query, order, published)

    dsl1 = {
      size: 800,

      filter: {
        and: [
          {
            terms: {
              business_id: business_ids,
            },
          },
        ],
      },
    }

    if published == true
      dsl1[:filter][:and] << {
        term: {
          published_status: true,
        },
      }
    end

    if published == false
      dsl1[:filter][:and] << {
        term: {
          published_status: false,
        },
      }
    end

    if content_category_ids.present?
      dsl1[:filter][:and] << {
        terms: {
          content_category_ids: content_category_ids,
        },
      }
    end

    if content_tag_ids.present?
      dsl1[:filter][:and] << {
        terms: {
          content_tag_ids: content_tag_ids,
        },
      }
    end

    if query.present?
      dsl1[:query] = {
        query_string: {
          fields: %w[title^2 content],
          # query: "#{@query}~", #tilde is for fuzzy searches
          query: query,
        }
      }
    else
      dsl1[:sort] = {
        published_at: :desc,
      }
    end

    Elasticsearch::Model.search(dsl1, [QuickPost]).records.to_a

  end

  def search_posts(business_ids, content_category_ids, content_tag_ids, query, order, published)

    dsl1 = {
      size: 800,

      filter: {
        and: [
          {
            terms: {
              business_id: business_ids,
            },
          },
        ],
      },
    }

    if published == true
      dsl1[:filter][:and] << {
        term: {
          published_status: true,
        },
      }
    end

    if published == false
      dsl1[:filter][:and] << {
        term: {
          published_status: false,
        },
      }
    end

    if content_category_ids.present?
      dsl1[:filter][:and] << {
        terms: {
          content_category_ids: content_category_ids,
        },
      }
    end

    if content_tag_ids.present?
      dsl1[:filter][:and] << {
        terms: {
          content_tag_ids: content_tag_ids,
        },
      }
    end

    if query.present?
      dsl1[:query] = {
        bool: {
          should: [
            {
              multi_match: {
                fields: %w[title^2 description],
                query: query
              }
            },
            {
              nested: {
                path: "post_sections",
                query: {
                  multi_match: {
                    fields: ["post_sections.heading", "post_sections.content"],
                    query: query
                  }
                }
              }
            }
          ]
        }
      }
    else
      dsl1[:sort] = {
        published_at: :desc,
      }
    end

    Elasticsearch::Model.search(dsl1, [Post, PostSection]).records.to_a


  end

  def search_offers(business_ids, content_category_ids, content_tag_ids, query, order, published)

    dsl1 = {
      size: 800,

      filter: {
        and: [
          {
            terms: {
              business_id: business_ids,
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
                }
              }
            ]
          }
        ]
      }
    }

    if published == true
      dsl1[:filter][:and] << {
        term: {
          published_status: true,
        },
      }
    end

    if published == false
      dsl1[:filter][:and] << {
        term: {
          published_status: false,
        },
      }
    end

    if content_category_ids.present?
      dsl1[:filter][:and] << {
        terms: {
          content_category_ids: content_category_ids,
        },
      }
    end

    if content_tag_ids.present?
      dsl1[:filter][:and] << {
        terms: {
          content_tag_ids: content_tag_ids,
        },
      }
    end

    if query.present?
      dsl1[:query] = {
        query_string: {
          fields: %w[title^2 offer description offer_code],
          # query: "#{@query}~", #tilde is for fuzzy searches
          query: query,
        }
      }
    else
      dsl1[:sort] = {
        published_at: :desc,
      }
    end

    Elasticsearch::Model.search(dsl1, [Offer]).records.to_a

  end

  def search_jobs(business_ids, content_category_ids, content_tag_ids, query, order, published)

    dsl1 = {
      size: 800,

      filter: {
        and: [
          {
            terms: {
              business_id: business_ids,
            },
          },
        ],
      },
    }

    if published == true
      dsl1[:filter][:and] << {
        term: {
          published_status: true,
        },
      }
    end

    if published == false
      dsl1[:filter][:and] << {
        term: {
          published_status: false,
        },
      }
    end

    if content_category_ids.present?
      dsl1[:filter][:and] << {
        terms: {
          content_category_ids: content_category_ids,
        },
      }
    end

    if content_tag_ids.present?
      dsl1[:filter][:and] << {
        terms: {
          content_tag_ids: content_tag_ids,
        },
      }
    end

    if query.present?
      dsl1[:query] = {
        query_string: {
          # fields: %w[title^2 subtitle description compensation_type compensation_range],
          #TODO - Coompensation_type and Compentsation_range where causing type mismatch - Would be nice to be able to search on these in the future but maybe better as a fiter instead of a query
          fields: %w[title^2 subtitle description],
          # query: "#{@query}~", #tilde is for fuzzy searches
          query: query,
        }
      }
    else
      dsl1[:sort] = {
        published_at: :desc,
      }
    end

    Elasticsearch::Model.search(dsl1, [Job]).records.to_a

  end

  def search_galleries(business_ids, content_category_ids, content_tag_ids, query, order, published)

    dsl1 = {
      size: 800,

      filter: {
        and: [
          {
            terms: {
              business_id: business_ids,
            },
          },
        ],
      },
    }

    if published == true
      dsl1[:filter][:and] << {
        term: {
          published_status: true,
        },
      }
    end

    if published == false
      dsl1[:filter][:and] << {
        term: {
          published_status: false,
        },
      }
    end

    if content_category_ids.present?
      dsl1[:filter][:and] << {
        terms: {
          content_category_ids: content_category_ids,
        },
      }
    end

    if content_tag_ids.present?
      dsl1[:filter][:and] << {
        terms: {
          content_tag_ids: content_tag_ids,
        },
      }
    end

    if query.present?
      dsl1[:query] = {
        query_string: {
          fields: %w[title^2 description],
          # query: "#{@query}~", #tilde is for fuzzy searches
          query: query,
        }
      }
    else
      dsl1[:sort] = {
        published_at: :desc,
      }
    end

    Elasticsearch::Model.search(dsl1, [Gallery]).records.to_a

  end

  def search_before_afters(business_ids, content_category_ids, content_tag_ids, query, order, published)

    dsl1 = {
      size: 800,

      filter: {
        and: [
          {
            terms: {
              business_id: business_ids,
            },
          },
        ],
      },
    }

    if published == true
      dsl1[:filter][:and] << {
        term: {
          published_status: true,
        },
      }
    end

    if published == false
      dsl1[:filter][:and] << {
        term: {
          published_status: false,
        },
      }
    end

    if content_category_ids.present?
      dsl1[:filter][:and] << {
        terms: {
          content_category_ids: content_category_ids,
        },
      }
    end

    if content_tag_ids.present?
      dsl1[:filter][:and] << {
        terms: {
          content_tag_ids: content_tag_ids,
        },
      }
    end

    if query.present?
      dsl1[:query] = {
        query_string: {
          fields: %w[title^2 description],
          # query: "#{@query}~", #tilde is for fuzzy searches
          query: query,
        }
      }
    else
      dsl1[:sort] = {
        published_at: :desc,
      }
    end

    Elasticsearch::Model.search(dsl1, [BeforeAfter]).records.to_a

  end

end
