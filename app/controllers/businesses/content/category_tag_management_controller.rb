class Businesses::Content::CategoryTagManagementController < Businesses::Content::BaseController
  layout false

  def index
    @content_categories = ContentCategory.where(business_id: @business.id).sort_by{ |m| m.name.downcase }
    @content_tags = ContentTag.where(business_id: @business.id).sort_by{ |m| m.name.downcase }
    render layout: 'business'
  end

  def delete_content_category
    @ids = params[:content_category][:content_category_ids]
    # @content_categories = ContentCategory.where("id IN (?)", @ids)

    if ContentCategory.where("id IN (?)", @ids).delete_all
      flash[:notice] = "Categories deleted."
      redirect_to business_content_category_tag_management_index_path
    else
      flash[:notice] = "Something went wrong, please try again."
      render 'index'
    end
  end

  def delete_content_tag
    @ids = params[:content_tag][:content_tag_ids]
    # @content_categories = ContentCategory.where("id IN (?)", @ids)

    if ContentTag.where("id IN (?)", @ids).delete_all
      flash[:notice] = "Tags deleted."
      redirect_to business_content_category_tag_management_index_path
    else
      flash[:notice] = "Something went wrong, please try again."
      render 'index'
    end
  end

  def new_content_category
    @content_category = @business.content_categories.new
  end

  def create_content_category
    @content_category = @business.content_categories.new
    @content_category.assign_attributes(content_category_params)

    if @content_category.save
      render json: @content_category.to_json
    else
      render :new, status: 422
    end
  end

  def create_content_tag
    if existing_tag = @business.content_tags.where('name ILIKE ?', "%#{content_tag_params[:name].to_s.strip.downcase}%").first
      render json: existing_tag.to_json
      return
    end

    @content_tag = @business.content_tags.new(content_tag_params)
    @content_tag.name.downcase!
    if @content_tag.save
      render json: @content_tag.to_json
    else
      render text: '', status: 422
    end
  end

  private

    def content_category_params
      params.require(:content_category).permit(
        :name,
      )
    end

    def content_tag_params
      params.require(:content_tag).permit(
        :name,
      )
    end

end
