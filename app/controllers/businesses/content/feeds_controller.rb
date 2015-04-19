class Businesses::Content::FeedsController < Businesses::Content::BaseController
  def show
    if query.present?
      @results = Elasticsearch::Model.search(search_dsl, classes).page(params[:page]).per(20).records
    else
      @results = Kaminari.paginate_array(record_arrays).page(params[:page]).per(20)
    end
  end

  private

  def query
    params[:query].to_s.strip
  end

  def search_dsl
    {
      query: {
        multi_match: {
          query: query,
          fields: %w[title^2 description],
        },
      },
      filter: {
        term: {
          business_id: @business.id,
        }
      },
    }
  end

  def classes
    [BeforeAfter, Gallery, Offer, Post, Project]
  end

  def record_arrays
    %i[before_afters galleries offers posts projects].map do |association|
      @business.send(association).order(created_at: :desc).limit(20)
    end.inject(&:+).sort_by(&:created_at).reverse
  end
end
