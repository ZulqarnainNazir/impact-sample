class SuperBusinessDatumDatatable < ApplicationDatatable
  delegate :edit_super_business_datum_path, to: :@view
  delegate :merge_with_super_business_datum_path, to: :@view

  private

  def data
    businesses.map do |business|
      [].tap do |column|
        column << business.id
        column << link_to("#{business.name}", edit_super_business_datum_path(business))

        #communities = business.communities.map(&:label).join(', ')
        if business.communities.present? && business.communities.count > 1
          communities = "#{business.communities.first.label} + #{business.communities.count.to_i - 1} more"
        elsif business.communities.present? && business.communities.count == 1
          communities = "#{business.communities.first.label}"
        else
          communities =  "None"
        end

        column << communities
        column << business.owned_companies.count

        if business.in_impact
          status = "Active"
        else
          status = "Inactive"
        end

        column << status
        column << business.updated_at.to_date.to_formatted_s(:long_ordinal)

        links = []
        # links << link_to('Show', business)
        links << link_to('Edit', edit_super_business_datum_path(business))
        links << link_to('Merge', merge_with_super_business_datum_path(business))

        column << links.join(' | ')
      end
    end
  end

  def count
    Business.count
  end

  def total_entries
    businesses.total_count

  end

  def businesses
    @businesses ||= fetch_businesses

  end

  def fetch_businesses

    # search_string = []
    #
    # columns.each do |col|
    #   search_string << "#{col} like :search"
    # end

    if sort_column == 'communities'
      businesses = Business.includes(:communities).order("communities.label #{sort_direction}")
      # elsif sort_colum == 'crm_companies'
      #   businesses = Business.includes(:communities)
      #   if sort_direction == 'asc'
      #     businesses = businesses.sort_by(&:owned_companies.count)
      #   else
      #     businesses = businesses.sort_by(&:owned_companies.count).reverse
      #   end
    else


      businesses = Business.includes(:communities).order("#{sort_column} #{sort_direction}")
    end

    # @businesses = Business.includes(:communities).order("id").search(params[:search]) #.page(params[:page]).per(20)
    businesses = businesses.page(page).per(per_page)
    # if params[:search][:value]
      #businesses = businesses.where(search_string.join(' or '), search: "%#{params[:search][:value]}%")
    businesses = businesses.where('lower(name) like ?', "%#{params[:search][:value].downcase}%" )
    # end
  end

  def columns
    #columns you want to be searchable here
    # %w(id name in_impact updated_at)
    %w(id name communities crm_companies in_impact updated_at)
  end

end
