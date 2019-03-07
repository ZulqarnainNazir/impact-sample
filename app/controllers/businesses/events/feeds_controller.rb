class Businesses::Events::FeedsController < Businesses::Events::BaseController

  def show
    # @results =
    #   Kaminari.paginate_array(
    #     ContentFeedSearch.new(
    #       @business,
    #       params[:unpublished],
    #       params[:published],
    #       params[:query],
    #       'EventDefinition',
    #       # content_category_ids: params[:categories],
    #       # content_tag_ids: params[:tags]
    #     ).search
    #   ).page(params[:page]).per(20)


    # @unpublished = params[:unpublished]
    @upcoming = params[:upcoming]
    @past = params[:past]
    @drafts = params[:drafts]
    @query = params[:query].to_s.strip


        dsl1 = {
          size: 800,

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

        dsl1[:filter][:and] << {
          term: {
            import_pending: false,
          },
        }


        if @past == 'true'
          dsl1[:filter][:and] << {
            range: {
              start_date: {
                lt: DateTime.now,
              },
            },
          }
          dsl1[:sort] = {
            start_date: :desc,
          }
        end

        if @upcoming == 'true'
          dsl1[:filter][:and] << {
            term: {
              published_status: true,
            },
          }
          dsl1[:filter][:and] << {
            range: {
              start_date: {
                gte: DateTime.now,
              },
            },
          }
          dsl1[:sort] = {
            start_date: :asc,
          }

        end

        if @drafts == 'true'
          dsl1[:filter][:and] << {
            term: {
              published_status: false
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
        end

        unless @upcoming == 'true' || @past == 'true' || @query.present?
          dsl1[:sort] = {
            created_at: :desc,
          }
        end

    content_classes = [EventDefinition]

    # byebug
    puts dsl1

    @results =
      Kaminari.paginate_array(
        Elasticsearch::Model.search(dsl1, content_classes).records.to_a
      ).page(params[:page]).per(20)


    # @categories = @business.content_categories
    # @tags = @business.content_tags
    # @post_types = @business.enabled_content_types #%w(event quick_post post before_after gallery offer job)
    # @post_types = %w(event quick_post post before_after gallery offer job)
    # @graph = FacebookAnalytics.new(facebook_token: @business.facebook_token)
  end
end
