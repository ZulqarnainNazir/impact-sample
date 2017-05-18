class Widgets::DirectoryWidgetsController < Widgets::BaseController
  def index
    @directory = DirectoryWidget.where(:uuid => params[:uuid]).first
    if @directory.blank?
      return false
    end
    @businesses = @directory.company_list.companies.includes(:company_location, :reviews, business: [:logo, :location, :reviews, :offers, :events, :event_definitions, :posts, :quick_posts, :galleries, :categories])
    @categories_search = @categories = @directory.company_list.company_list_categories
    @masonry = true

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
    @directory = DirectoryWidget.where(:uuid => params[:uuid]).first
    if @directory.blank?
      return false
    end
    @business = @directory.business.owned_companies.find(params[:business_id])
  end
end
