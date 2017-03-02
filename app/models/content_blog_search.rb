class ContentBlogSearch
  def initialize(business, query = '', content_types: [], content_category_ids: [], content_tag_ids: [])
    @business = business
    @query = query.to_s.strip
    @content_types = content_types
    @content_category_ids = content_category_ids
    @content_tag_ids = content_tag_ids
  end

  def search
    dsl1 = {
      size: 800,
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
      dsl1[:filter][:and] << {
        terms: {
          content_category_ids: @content_category_ids,
        },
      }
    end

    if @content_tag_ids.any?
      dsl1[:filter][:and] << {
        terms: {
          content_tag_ids: @content_tag_ids,
        },
      }
    end

    if @query.present?
      dsl1[:query] = {
        query_string: {
          fields: %w[title^2 description content heading offer],
          # query: "#{@query}~", #tilde is for fuzzy searches
          query: @query,
        }
      }
    else
      dsl1[:sort] = {
        sorting_date: :desc,
      }
    end
#END OF DSL1


    dsl2 = {
      size: 800,
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
      dsl2[:filter][:and] << {
        terms: {
          content_category_ids: @content_category_ids,
        },
      }
    end

    if @content_tag_ids.any?
      dsl2[:filter][:and] << {
        terms: {
          content_tag_ids: @content_tag_ids,
        },
      }
    end

    if @query.present?
      dsl2[:query] = {
        bool: {
          should: [
            {
              multi_match: {
                fields: %w[title^2 description content heading],
                query: @query
              }   
            },
            {
              nested: {
                path: "post_sections",
                query: {
                  multi_match: {
                    fields: ["post_sections.content", "post_sections.heading"], 
                    query: @query
                  }
                }
              }
            }
          ]
        }
      }
    else
      dsl2[:sort] = {
        sorting_date: :desc,
      }
    end
#END OF DSL2

    if @content_types.present? && @content_types.any?
      content_classes = []

      @content_types.each do |type|
        if %w[QuickPost Event Gallery BeforeAfter Offer Post].include?(type)
          content_classes << type.constantize
        end
        content_classes << QuickPost if type == 'Post'
        content_classes << PostSection if type == 'Post'
        # content_classes << Post if type == 'CustomPost'
      end
      if content_classes.include?(Event)
        # content_classes.delete(Event)
        content_classes << EventDefinition
      end
    else
      content_classes = [QuickPost, EventDefinition, Gallery, BeforeAfter, Offer, Post]
    end

    if @content_types.present? && @content_types.any?
      content_classes_without_post = []

      @content_types.each do |type|
        if %w[QuickPost Event Gallery BeforeAfter Offer Post].include?(type)
          content_classes_without_post << type.constantize
        end
        content_classes_without_post << QuickPost if type == 'Post'
      end
      if content_classes_without_post.include?(Post)
        # content_classes.delete(Event)
        content_classes_without_post.delete(Post)
      end
    else
      content_classes_without_post = [QuickPost, EventDefinition, Gallery, BeforeAfter, Offer]
    end

    if @content_types.present? && @content_types.any? && @content_types.include?("Post")
      content_classes_just_post = []
      content_classes_just_post << [Post]
    else
      content_classes_just_post = [Post]
    end

    if @query.blank? && @content_types.count == 0

      Elasticsearch::Model.search(dsl1, content_classes).records.to_a

    elsif !@query.blank? && @content_types.count > 1 && @content_types.include?('Post')

      (
        (Elasticsearch::Model.search(dsl1, content_classes_without_post).records) + 
        (Elasticsearch::Model.search(dsl2, content_classes_just_post).records)
      ).to_a.sort_by {|obj| obj.published_on}.reverse!

    elsif !@query.blank? && @content_types.count > 1 && !@content_types.include?('Post')

      Elasticsearch::Model.search(dsl1, content_classes_without_post).records.to_a

    elsif !@query.blank? && @content_types.count == 1 && @content_types.include?('Post')

      (
        (Elasticsearch::Model.search(dsl1, [QuickPost]).records) + 
        (Elasticsearch::Model.search(dsl2, content_classes_just_post).records)
      ).to_a.sort_by {|obj| obj.published_on}.reverse!

    else

      Elasticsearch::Model.search(dsl1, content_classes).records.to_a

    end

  end
end
