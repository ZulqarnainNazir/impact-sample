class Businesses::Website::AboutPagesController < Businesses::Website::BaseController
  layout 'application'

  before_action do
    @about_page = @website.about_page || @website.build_about_page
  end

  def update
    update_resource @about_page, about_page_params, location: [:edit, @business, :website_about_page]
  end

  private

  def about_page_params
    params.require(:about_page).permit(
      :title,
      blocks_attributes: [
        :id,
        :type,
        :theme,
        :style,
        :heading,
        :subheading,
        :text,
        :label,
        :_destroy,
      ],
    ).deep_merge(
      pathname: 'about',
      name: 'About',
    )
  end
end
