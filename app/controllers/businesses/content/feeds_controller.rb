class Businesses::Content::FeedsController < Businesses::Content::BaseController
  def show
    @results = ContentSearch.new(@business, params[:query], strict: false).search.page(params[:page]).per(20).records
  end
end
