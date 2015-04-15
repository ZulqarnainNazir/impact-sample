class Businesses::Website::MetaController < Businesses::Website::BaseController
  def update
    update_resource @website, meta_params, location: [:edit, @business, :website_meta]
  end

  private

  def meta_params
    params.require(:website).permit(
      :google_analytics_id,
      :head_injection,
      :footer_injection,
    )
  end
end
