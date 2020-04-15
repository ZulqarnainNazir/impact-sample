class BusinessCrmCompaniesDatatable < ApplicationDatatable
  delegate :edit_business_crm_company_path, to: :@view
  delegate :business_crm_company_lists_path, to: :@view
  delegate :new_business_crm_invite_path, to: :@view
  delegate :business_crm_company_path, to: :@view


  private

  def data
    companies.map do |company|
      [].tap do |column|
        column << link_to("#{company.business.name}", edit_business_crm_company_path(params[:business_id], company.id))

        if company.company_lists.count >= 1
          column << "In #{company.company_lists.count} Local Networks"
        else
          column << link_to("Add to Network", business_crm_company_lists_path(params[:business_id]), class: 'btn btn-success btn-sm')
        end

        if company.business.in_impact
          column << "Claimed"
        else
          column << link_to("Request Support", new_business_crm_invite_path(params[:business_id], company_id: company.id), class: 'btn btn-xs btn-default')
        end

        column << company.business.get_estimated_reach
        column << link_to("#{company.business.website_url}", company.business.website_url, target: '_blank')

        column << (company.business.location.phone_number? ? company.business.location.phone_number : '--')

        column << company.business.location.street1
        column << company.business.location.city
        column << company.business.location.state

        column << link_to("Delete", business_crm_company_path(params[:business_id], company.id), class: 'btn btn-xs btn-danger', method: :delete, data: { confirm: 'Are you sure?' })

      end
    end
  end

  def count
    Business.find(params[:business_id]).owned_companies.count
  end

  def total_entries
    companies.total_count

  end

  def companies
    @companies ||= fetch_companies

  end

  def fetch_companies
    # || 'street1' || 'city' || 'state'
    # if sort_column == 'phone_number'
    #   companies = Business.find(params[:business_id]).owned_companies.includes(business: [:location]).order("businesses.location.phone_number #{sort_direction}")
    #   # elsif sort_column == 'crm_companies'
    #   # businesses = Business.includes(:communities).order("owned_companies.count #{sort_direction}")
    #   # businesses = Business.includes(:communities)
    #   # if sort_direction == 'asc'
    #   #   businesses = businesses.sort_by(&:owned_companies.count)
    #   # else
    #   #   businesses = businesses.sort_by(&:owned_companies.count).reverse
    #   # end
    # else
    companies = Business.find(params[:business_id]).owned_companies.includes(business: [:location]).order("#{sort_column} #{sort_direction}")
    # end
    companies = companies.page(page).per(per_page)
    if params[:search][:value]
      companies = companies.where('lower(name) like ?', "%#{params[:search][:value].downcase}%" )
    end
  end

  def columns
    #columns you want to be searchable here
    %w(name supporting supporter estimated_monthly_reach website_url phone_number street1 city state)

  end

end
