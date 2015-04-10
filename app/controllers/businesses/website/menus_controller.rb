class Businesses::Website::MenusController < Businesses::Website::BaseController
  def update
    update_resource @website, menus_params, location: [:edit, @business, :website_menus]
  end

  private

  def menus_params
    params.require(:website).permit(
      :header_menu,
      :footer_menu,
    )
  end
end
