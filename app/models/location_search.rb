class LocationSearch
  def initialize(query, location_id = nil)
    @query = '*' + query.to_s.strip + '*'
    @location_id = location_id.to_i
  end

  def search
    dsl = {
      filter: {
        and: [
          exists: {
            field: 'full_address',
          },
        ],
      },
      query: {
        query_string: {
          query: @query,
          fields: %w[name^2 full_address],
        },
      },
    }

    if @location_id > 0
      dsl[:filter][:and].push(
        not: {
          term: {
            id: @location_id,
          },
        }
      )
    end

    Elasticsearch::Model.search(dsl, [Location])
  end
end
