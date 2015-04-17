class Businesses::Website::CustomPagesController < Businesses::Website::BaseController
  layout 'application'

  before_action only: new_actions do
    @custom_page = @website.webpages.new(type: 'CustomPage')
  end

  before_action only: member_actions do
    @custom_page = @website.webpages.custom.find(params[:id])
  end

  def create
    create_resource @custom_page, custom_page_params, location: [:edit, @business, :website, @custom_page]
  end

  def update
    update_resource @custom_page, custom_page_params, location: [:edit, @business, :website, @custom_page]
  end

  private

  def custom_page_params
    basic_custom_page_params.tap do |page_params|
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

  def basic_custom_page_params
    params.require(:custom_page).permit(
      :title,
      :pathname,
      :name,
      :block_type_order,
      :call_to_action_blocks_per_row,
      hero_block_attributes: block_attributes,
      specialty_blocks_attributes: block_attributes,
      tagline_blocks_attributes: block_attributes,
      call_to_action_blocks_attributes: block_attributes,
      content_blocks_attributes: block_attributes,
    )
  end
end
