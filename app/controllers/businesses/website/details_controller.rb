class Businesses::Website::DetailsController < Businesses::Website::BaseController
  def edit
    @website.webhosts.build
  end

  def update
    update_resource @website, website_params, location: [:edit, @business, :website_details] do |success|
      @website.webhosts.build unless success
    end
  end

  private

  def website_params
    params.require(:website).permit(
      :subdomain,
      webhosts_attributes: [
        :id,
        :name,
        :primary,
        :_destroy,
      ]
    )
  end
end
