class Elasticsearch::Model::Multimodel
  def default_per_page
    20
  end
end

class Elasticsearch::Model::Response::Records
  def max_pages
    500
  end

  def max_records
    500
  end
end
