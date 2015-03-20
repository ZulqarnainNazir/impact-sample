class Onboard::Website::PagesController < Onboard::Website::BaseController
  before_action do
    @business = current_user.businesses.find(params[:business_id])
  end

  before_action do
    if !@business.website
      redirect_to [:edit_onboard_website, @business, :website]
    else
      @website = @business.website
    end
  end

  def edit
    @home_page = @website.home_page || @website.build_home_page
    @about_page = @website.about_page || @website.build_about_page
    @contact_page = @website.contact_page || @website.build_contact_page
    @custom_pages = @website.pages.custom
    @custom_pages.push @website.pages.build
  end

  def update
    update_resource @website, website_params, location: [@business, :dashboard] do |success|
      unless success
        @home_page = @website.home_page || @website.build_home_page
        @about_page = @website.about_page || @website.build_about_page
        @contact_page = @website.contact_page || @website.build_contact_page
        @custom_pages = @website.pages.select(&:custom_page?)
        @custom_pages.push @website.pages.build
      end
    end
  end

  private

  def website_params
    params.require(:website).permit(
      home_page_attributes: [
        :_destroy,
      ],
      about_page_attributes: [
        :_destroy,
      ],
      contact_page_attributes: [
        :_destroy,
      ],
      pages_attributes: [
        :type,
        :title,
        :_destroy,
      ],
    ).deep_merge(
      home_page_attributes: {
        title: @business.name,
        pathname: '',
        hero_title: @business.name,
        hero_text: @business.description,
        tagline_text: @business.tagline,
      },
      about_page_attributes: {
        title: "About #{@business.name}",
        pathname: 'about',
        about_heading: @business.name,
        about_text: @business.description,
      },
      contact_page_attributes: {
        title: "Contact #{@business.name}",
        pathname: 'contact',
        text: @business.description
      },
    )
  end
end
