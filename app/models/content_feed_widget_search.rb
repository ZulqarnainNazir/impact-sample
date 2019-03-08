#IMPORTANT: Look at the comments *at the end* of the code below for guidance on how
#the code works, why it was set-up the way it was as of 3.19.17, and for info RE associated
#rake tasks.
class ContentFeedWidgetSearch
  def initialize(widget, business, query = '', content_types: [], content_category_ids: [], content_tag_ids: [], include_past: false)
    @widget = widget
    @business = business
    @business_ids = @widget.get_business_ids #business_ids should be an array; returns array of Business ids, or empty array
    if @widget.show_our_content == true
      @business_ids << @business.id #includes parent business' content
    end
    @query = query.to_s.strip
    @content_types = content_types
    @content_category_ids = content_category_ids
    @content_tag_ids = content_tag_ids
    @include_past = include_past
  end

  def search
    #dsl1 is meant to be a general use query. it does not query a cluster for
    #nested content. dsl2 does that.
    dsl1 = {
      size: 800,
      # query: {
      #     term: {
      #       published_status: true
      #     }
      # },

      filter: {
        and: [
          {
            terms: {
              business_id: @business_ids,
              #example from documentation: "terms" : { "user" : ["kimchy", "elasticsearch"]}
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

    dsl1[:filter][:and] << {
      term: {
        published_status: !false,
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

    #dsl2 pulls nested content, and is meant to target Post and PostSections
    #specifically.
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
            terms: {
              business_id: @business_ids,
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

    #all content types submitted, or all types
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
      content_classes = [QuickPost, EventDefinition, Event, Gallery, BeforeAfter, Offer, Post]
    end

    #without post
    if @content_types.present? && @content_types.any?
      content_classes_without_post = []

      @content_types.each do |type|
        if %w[QuickPost Event Gallery BeforeAfter Offer Post].include?(type)
          content_classes_without_post << type.constantize
        end
        content_classes_without_post << QuickPost if type == 'Post'
      end
      if content_classes_without_post.include?(Event)
        # content_classes.delete(Event)
        content_classes_without_post << EventDefinition
      end
      if content_classes_without_post.include?(Post)
        # content_classes.delete(Event)
        content_classes_without_post.delete(Post)
      end
    else
      content_classes_without_post = [QuickPost, Event, EventDefinition, Gallery, BeforeAfter, Offer]
    end

    #just post
    if @content_types.present? && @content_types.any? && @content_types.include?("Post")
      content_classes_just_post = []
      content_classes_just_post << [Post]
    else
      content_classes_just_post = [Post]
    end

    #combining the payloads delivered to app by ElasticSearch
    if @query.blank? && @content_types.count == 0
      #if the user searches for nothing, and specifies no specific content types,
      #search for everything in all content types.

      Elasticsearch::Model.search(dsl1, content_classes).records.to_a

    elsif !@query.blank? && @content_types.count > 1 && @content_types.include?('Post')
      #if the user has specified a query string, and has specified a content_type,
      #and that content_type includes Post, then execute TWO queries. The first
      #for content types exclusive of Post and PostSection, the second query
      #only searches for JUST Post and PostSection using query dsl2. This is
      #because we need a specific, customized query just for the nested content
      #type PostSections and its parent, Post.

      (
        (Elasticsearch::Model.search(dsl1, content_classes_without_post).records) +
        (Elasticsearch::Model.search(dsl2, content_classes_just_post).records)
      ).to_a.sort_by {|obj| obj.published_at}.reverse!

    elsif !@query.blank? && @content_types.count > 1 && !@content_types.include?('Post')
      #if the query string is not empty, and content types are specified, but those
      #selected types do not include Post, then do not execute two queries.
      #use the general query dsl1.

      Elasticsearch::Model.search(dsl1, content_classes_without_post).records.to_a

    elsif !@query.blank? && @content_types.count == 1 && @content_types.include?('Post')
      #self-explanatory based on comments above.
      (
        (Elasticsearch::Model.search(dsl1, [QuickPost]).records) +
        (Elasticsearch::Model.search(dsl2, content_classes_just_post).records)
      ).to_a.sort_by {|obj| obj.published_at}.reverse!

    else

      Elasticsearch::Model.search(dsl1, content_classes).records.to_a

    end

  end
end

=begin

  Context:
  We've updated ElasticSearch to version 2.4 as of 3.19.17. This update resulted
  in some queries that originally pulled nested data no longer worked. In particular,
  it meant that searches for the content type Post broke the app - Post has_many PostSections,
  which, from ElasticSearch's perspective, is a nested content type of Post.
  The upgrade broke our nested content type queries. As such, we had to write some new queries
  for contact_blog_search.rb and content_feed_search.rb

  How the New Queries Work
  There are two new queries that work in conjunction with each other: dsl1 and dsl2.
  The first works by first pulling all content types the user wants.
  The second is a special query that pulls Post, and nested content of Post (PostSection).
  The code then combines the results of each query into an array, parses them, and presents
  them to the user. You can find these queries in models/contact_blog_search.rb and
  models/content_feed_search.rb. Take note that whether or not the first query looks
  for all content types, or just some, depends on a few factors you'll need to
  review in the code. Also take note that how queries are combined after they are
  made into arrays depends on a few factors, too. Again, please review the code.

  The Need for New ElasticSearch Rake Tasks
  Unfortunately, our production cluster on Bonsai would not map our nested data fields for
  Post correctly. Of course, on staging, it do so without issue. Our work-around was to write
  special rake tasks that, using HTTParty, issue mapping, indexing, and importing POST commands
  directly to our Bonsai cluster. Previously, we relied on rake tasks that came bundled with our
  various ElasticSearch gems.

  What the New Rake Tasks Are
  There are two new rake tasks: create_post_index and custom_elasticsearch_import.
  If you need to import new data, use custom_elasticsearch_import.
  It will import data into all existing indices. If you need to destroy the
  Post or PostSection indices for any reason, or change their mappings (such as added a field),
  use/modify "create_post_index" accordingly. It will get the job done of creating and mapping
  the index on our Bonsai cluster the way you expect.

  Note: It is critical that you understand how the rake tasks work - review them.
  If you have any questions, ask Brian, so he can pull in another dev who's worked on ES before.
  Also, if you want to experiment with POST requests to Bonsai clusters,
  use the interface provided by Bonsai. Go the cluster management dashboard,
  and you'll see the option to do this. Of course, experiment on staging.

=end
