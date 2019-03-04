class Businesses::Crm::CompanyListsController < Businesses::BaseController
  # before_action only: [:new, :create, :edit, :update] do
  #   if !@business.module_active?(2)
  #     messages = AccountModule.create_module(@business.id, {kind: 2, active: true})
  #     @business.reload
  #     # flash[:appcues_event] = messages[0]
  #     flash[:notice] = messages[1]
  #   end
  # end
  #
  # before_action -> { confirm_module_activated(2) }, except: [:new, :edit, :index]

  before_action only: new_actions do
    @company_list = @business.company_lists.new
  end

  before_action only: member_actions do
    @company_list = @business.company_lists.find(params[:id])
  end

  def new
    @company_list.company_list_categories << CompanyListCategory.new

    if params[:json] == 'true'
      @company_list.name = "Local Network #{@business.company_lists.size}"
      render template: 'businesses/crm/company_lists/_new',
             locals: { company_list: @company_list }, layout: false
    end
  end

  def edit
    if params[:json] == 'true'
      render template: 'businesses/crm/company_lists/_edit',
             locals: { company_list: @company_list }, layout: false
    end
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
    if params[:json] == 'true'
      @company_list.assign_attributes(company_list_params)
      if @company_list.save
        render plain: @company_list.to_json, content_type: 'application/json', layout: false
      else
        render plain: @company_list.errors.to_json, content_type: 'application/json', layout: false, status: 422
      end
    else
      create_resource @company_list, company_list_params, location: [:edit, @business, :crm, @company_list]
    end

    intercom_event 'followed_a_business'
  end

  def update
    if params[:json] == 'true'
      @company_list.update_attributes(company_list_params)
      if @company_list.save
        render plain: @company_list.to_json, content_type: 'application/json', layout: false
      else
        render plain: @company_list.errors.to_json, content_type: 'application/json', layout: false, status: 422
      end
    else
      if @company_list.update_attributes(company_list_params)
        redirect_to [:edit, @business, :crm, @company_list], :flash => { :notice => "Local Network Saved Successfully" }
      else
        render 'edit'
      end
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
