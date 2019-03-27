class SuperBusinessDatumDatatable < ApplicationDatatable
  delegate :edit_super_business_datum_path, to: :@view
  delegate :merge_with_super_business_datum_path, to: :@view

  private

  def data
    businesses.map do |business|
      [].tap do |column|
        column << business.id
        column << link_to("#{business.name}", edit_super_business_datum_path(business))

        if business.communities.present?
          communities = business.communities.map(&:label).join(', ')
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

    search_string = []

    columns.each do |term|
      search_string << "#{term} like :search"
    end

    # @businesses = Business.includes(:communities).order("id").search(params[:search]) #.page(params[:page]).per(20)
    businesses = Business.includes(:communities).order("#{sort_colum} #{sort_direction}")
    businesses = businesses.page(page).per(per_page)
    # businesses = businesses.where(search_string.join(' or '), search: "%#{params[:search][:value]}%")
    businesses = businesses.where('lower(name) like ?', "%#{params[:search][:value].downcase}%" )

  end

  def columns
    %w(id name updated_at)
  end

end
