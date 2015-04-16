class Businesses::Website::HomePagesController < Businesses::Website::BaseController
  layout 'application'

  before_action do
    @home_page = @website.home_page || @website.build_home_page
  end

  def update
    update_resource @home_page, home_page_params, location: [:edit, @business, :website_home_page]
  end

  private

  def home_page_params
    basic_home_page_params.tap do |page_params|
      if page_params[:hero_block_attributes]
        page_params[:hero_block_attributes].merge! image_business: @business, image_user: current_user
      end

      if page_params[:specialty_blocks_attributes] && page_params[:specialty_blocks_attributes].kind_of?(Hash)
        page_params[:specialty_blocks_attributes].each do |key, attributes|
          attributes.merge! image_business: @business, image_user: current_user
        end
      end

      if page_params[:call_to_action_blocks_attributes] && page_params[:call_to_action_blocks_attributes].kind_of?(Hash)
        page_params[:call_to_action_blocks_attributes].each do |key, attributes|
          attributes.merge! image_business: @business, image_user: current_user
        end
      end

      if page_params[:content_blocks_attributes] && page_params[:content_blocks_attributes].kind_of?(Hash)
        page_params[:content_blocks_attributes].each do |key, attributes|
          attributes.merge! image_business: @business, image_user: current_user
        end
      end
    end
  end

  def basic_home_page_params
    params.require(:home_page).permit(
      :title,
      hero_block_attributes: block_attributes,
      specialty_blocks_attributes: block_attributes,
      tagline_blocks_attributes: block_attributes,
      call_to_action_blocks_attributes: block_attributes,
      content_blocks_attributes: block_attributes,
    ).deep_merge(
      pathname: '',
      name: 'Homepage',
    )
  end
end
