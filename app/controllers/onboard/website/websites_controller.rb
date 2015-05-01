class Onboard::Website::WebsitesController < Onboard::Website::BaseController
  before_action do
    @business = current_user.authorized_businesses.find(params[:business_id])

    unless @business.location && @business.website
      redirect_to [@website, :dashboard], alert: 'No Location or Website Found'
    end

    unless @business.website.home_page
      @business.website.create_home_page!(name: 'Homepage', pathname: '', title: @business.name)
    end

    unless @business.website.about_page
      @business.website.create_about_page!(name: 'About', pathname: 'about', title: "About #{@business.name}")
    end

    unless @business.website.blog_page
      @business.website.create_blog_page!(name: 'Blog', pathname: 'blog', title: "#{@business.name} Blog")
    end

    unless @business.website.contact_page
      @business.website.create_contact_page!(name: 'Contact', pathname: 'contact', title: "Contact #{@business.name}")
    end

    @business.lines.each do |line|
      unless @business.website.webpages.find { |page| page.external_line_id == line.id }
        @business.website.webpages.create!(type: 'CustomPage', title: line.title, external_line_id: line.id)
      end
    end
  end

  def update
    update_resource @business.website, website_params, context: :setup, location: [:edit_onboard_website, @business, :theme]
  end

  private

  def website_params
    params.require(:website).permit(
      webpages_attributes: [
        :type,
        :title,
        :_destroy,
      ],
    )
  end
end
