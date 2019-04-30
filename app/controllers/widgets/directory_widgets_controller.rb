class Widgets::DirectoryWidgetsController < Widgets::BaseController

  def index
    @directory = DirectoryWidget.where(:uuid => params[:uuid]).first
    if @directory.blank?
      return false
    end
    @businesses = @directory.company_list.companies.includes(:company_location, :reviews, business: [:logo, :location, :reviews, :offers, :categories])
    @categories_search = @categories = @directory.company_list.company_list_categories

    if !params[:query].blank?
      @businesses = @businesses.where("companies.name ILIKE ?", "%#{params[:query]}%")
    end
    if !params[:category].blank?
      @categories_search = @categories_search.where("company_list_categories.id = ?", params[:category])
    end
    @business = @directory.business
    if !params[:widget_layout].blank?
      @widget.layout = params[:widget_layout]
    end
  end

  def show
    # For asychronously loading widget content via ajax
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'GET'


    @directory = DirectoryWidget.where(:uuid => params[:uuid]).first
    if @directory.blank?
      return false
    end
    @business = @directory.business.owned_companies.find_by(company_business_id: params[:business_id]).business


    if params[:content_types]
        @content_types = params[:content_types]
    else
      @content_types = "QuickPost Offer Job Gallery BeforeAfter Post".split
    end

    @content = get_content(business: @business, content_types: @content_types, order: 'desc', page: params[:page], per_page: '3')
  end
end
