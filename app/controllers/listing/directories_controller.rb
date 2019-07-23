class Listing::DirectoriesController < ApplicationController
  layout "listing"

  include ApplicationHelper
  include ContentSearchConcern

  before_action do
    @business = Business.listing_lookup(params[:lookup])

    if @business.events.any?
      @calendar_widget = CalendarWidget.new         # empty "fake" calendar widget in order to display business events
    end

    @content_feed_widget = ContentFeedWidget.new  # empty "fake" content widget in order to display business content
    @content_feed_widget.business = @business
    @content_feed_widget.max_items = 12
    @posts = get_content(
      business: @content_feed_widget.business,
      embed: @content_feed_widget,
      content_types: ALL_CONTENT_TYPES,
      content_category_ids: @content_feed_widget.content_category_ids.to_s.split(' ').map(&:to_i),
      content_tag_ids: @content_feed_widget.content_tag_ids.to_s.split(' ').map(&:to_i),
      order: 'desc',
      page: params[:page],
      per_page: @content_feed_widget.max_items
    )

    @truncate_rev = true
    @reviews = @business.reviews.published.order(reviewed_at: :desc).page(params[:page]).per(20)
  end

  # def index
  #   @business = Business.listing_lookup(params[:lookup])
  #   @directories = @business.directory_widgets
  #   if @directories.size == 0
  #     return false
  #   end
  #   if @directories.size == 1
  #     redirect_to listing_directory_path(@business, @business.directory_widgets.first.id)
  #   end
  #
  #   default = {:id => @directories.first.id}
  #   if params[:directory].nil? && !params[:directory_same].nil?
  #     params[:directory] = {:id => params[:directory_same]}
  #   elsif params[:directory].nil?
  #     params[:directory] = default
  #   end
  #   @directory = DirectoryWidget.find(params[:directory][:id])
  #
  #
  #   @businesses = @directory.company_list.companies.includes(:company_location, :reviews, business: [:logo, :location, :reviews, :offers, :categories])
  #   @categories_search = @categories = @directory.company_list.company_list_categories
  #
  #   if !params[:query].blank?
  #     @businesses = @businesses.where("companies.name ILIKE ?", "%#{params[:query]}%")
  #   end
  #   if !params[:category].blank?
  #     @categories_search = @categories_search.where("company_list_categories.id = ?", params[:category])
  #   end
  #   @business = @directory.business
  #   if !params[:widget_layout].blank?
  #     @widget.layout = params[:widget_layout]
  #   end
  #
  # end

  def show
    @business = Business.listing_lookup(params[:lookup])
    @directory = @business.directory_widgets.find(params[:id])
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
=begin
    # For asychronously loading widget content via ajax
    headers['Access-Control-Allow-Origin'] = '*'

    @directory = DirectoryWidget.where(:uuid => params[:uuid]).first
    if @directory.blank?
      return false
    end
    @business = @directory.business.owned_companies.find_by(company_business_id: params[:business_id]).business
=end
  end
end
