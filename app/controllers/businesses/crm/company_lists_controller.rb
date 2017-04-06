class Businesses::Crm::CompanyListsController < Businesses::BaseController

  before_action only: member_actions do
    @company_list = @business.company_lists.find(params[:id])
  end

  def new
    @company_list = @business.company_lists.new
    @company_list.company_list_categories << CompanyListCategory.new
  end

  def index
    scope = @business.company_lists
    query = params[:query].to_s.strip

    if query.present?
      scope = scope.where('name ILIKE ?', "%#{query}%")
    end

    @company_lists = scope.page(params[:page]).per(20)
  end

  def create
    @company_list = @business.company_lists.new
    create_resource @company_list, company_list_params, location: [:edit, @business, :crm, @company_list]
  end

  def update
    company_list = @business.company_lists.find(params[:id])
    if company_list.update_attributes(company_list_params)
      redirect_to [:edit, @business, :crm, @company_list], :flash => { :notice => "List Saved Successfully" }
    else
      render 'edit'
    end
  end

  def destroy
    CompanyList.destroy(@company_list.id)
    redirect_to [@business, :crm_company_lists]
  end

  private

  def company_list_params
    params.require(:company_list).permit(:name, :sort_by, :company_ids => [], 
                                             :company_list_categories_attributes => [
                                               :id, :label, :position, :_destroy, :company_ids => []])
  end

end
