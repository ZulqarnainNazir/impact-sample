module ContentSearchConcern
  extend ActiveSupport::Concern

  # Finds content for a given business for display in widget, web builder or listings
  def get_content(business, embed = '', query = '', content_types = [], content_category_ids = [], content_tag_ids = [], order = "desc", page = 1, per_page = 10)
    # Notes:
    # Need to use scopes for published/draft/all for admin views

    # Initialize
    @business = business
    @embed = embed
    @query = query.to_s.strip
    @content_types = content_types
    @content_category_ids = content_category_ids
    @content_tag_ids = content_tag_ids
    @order = order
    @page = page
    @per_page = per_page

    # byebug

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


    # Perfom Elsticsearch queries
    @all_content = []
    @content_types.each do |type|
      case type
      when 'QuickPost'
        quick_posts = search_quick_posts(@business_ids, @content_category_ids, @content_tag_ids, @query, @order)
        @all_content += quick_posts
      when 'Post'
        posts = search_posts(@business_ids, @content_category_ids, @content_tag_ids, @query, @order)
        @all_content += posts
      when 'Offer'
        offers = search_offers(@business_ids, @content_category_ids, @content_tag_ids, @query, @order)
        @all_content += offers
      when 'Job'
        jobs = search_jobs(@business_ids, @content_category_ids, @content_tag_ids, @query, @order)
        @all_content += jobs
      when 'Gallery'
        galleries = search_galleries(@business_ids, @content_category_ids, @content_tag_ids, @query, @order)
        @all_content += galleries
      when 'BeforeAfter'
        before_afters = search_before_afters(@business_ids, @content_category_ids, @content_tag_ids, @query, @order)
        @all_content += before_afters
      end
    end

    # byebug

    #Sort and return content objects
    # (@quick_posts + @posts + @offers + @jobs + @galleries + @before_afters).sort_by {|obj| obj.published_at}.reverse!
    Kaminari.paginate_array(@all_content.sort_by {|obj| obj.published_at}.reverse!).page(@page).per(@per_page)


  end

  def search_quick_posts(business_ids, content_category_ids, content_tag_ids, query, order)

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

    dsl1[:filter][:and] << {
      term: {
        published_status: true,
      },
    }

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

  def search_posts(business_ids, content_category_ids, content_tag_ids, query, order)

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

    dsl1[:filter][:and] << {
      term: {
        published_status: true,
      },
    }

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
                query: @query
              }
            },
            {
              nested: {
                path: "post_sections",
                query: {
                  multi_match: {
                    fields: ["post_sections.heading", "post_sections.content"],
                    query: @query
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


  def search_offers(business_ids, content_category_ids, content_tag_ids, query, order)

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

    dsl1[:filter][:and] << {
      term: {
        published_status: true,
      },
    }

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

  def search_jobs(business_ids, content_category_ids, content_tag_ids, query, order)

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

    dsl1[:filter][:and] << {
      term: {
        published_status: true,
      },
    }

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
          fields: %w[title^2 subtitle description compensation_type compensation_range],
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

  def search_galleries(business_ids, content_category_ids, content_tag_ids, query, order)

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

    dsl1[:filter][:and] << {
      term: {
        published_status: true,
      },
    }

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

  def search_before_afters(business_ids, content_category_ids, content_tag_ids, query, order)

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

    dsl1[:filter][:and] << {
      term: {
        published_status: true,
      },
    }

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
