class Onboard::Website::WebsitesController < Onboard::Website::BaseController
  before_action do
    @business = current_user.authorized_businesses.find(params[:business_id])

    unless @business.location && @business.website
      redirect_to [@website, :dashboard], alert: 'No Location or Website Found'
    end
  end

  def update
    update_resource @business.website, website_params, context: :setup, location: [:edit_onboard_website, @business, :theme]
  end

  private

  def website_params
    params.require(:website).permit(
      :subdomain,
      home_page_attributes: [
        :_destroy,
      ],
      about_page_attributes: [
        :_destroy,
      ],
      blog_page_attributes: [
        :_destroy,
      ],
      contact_page_attributes: [
        :_destroy,
      ],
      webpages_attributes: [
        :type,
        :title,
        :_destroy,
      ],
    ).deep_merge(
      home_page_attributes: {
        name: 'Homepage',
        pathname: '',
        title: @business.name,
      },
      about_page_attributes: {
        name: 'About',
        pathname: 'about',
        title: "About #{@business.name}",
      },
      blog_page_attributes: {
        name: 'Blog',
        pathname: 'blog',
        title: "#{@business.name} Blog",
      },
      contact_page_attributes: {
        name: 'Contact',
        pathname: 'contact',
        title: "Contact #{@business.name}",
      },
    )
  end
end
