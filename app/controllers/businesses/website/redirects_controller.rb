class Businesses::Website::RedirectsController < Businesses::Website::BaseController
  before_action only: new_actions do
    @redirect = @website.redirects.new
  end

  before_action only: member_actions do
    @redirect = @website.redirects.find(params[:id])
  end

  def index
    @redirects = @website.redirects.order(created_at: :desc).page(params[:page]).per(20)
  end

  def create
    create_resource @redirect, redirect_params, location: [@business, :website_redirects]
  end

  def update
    update_resource @redirect, redirect_params, location: [@business, :website_redirects]
  end

  def destroy
    destroy_resource @redirect, location: [@business, :website_redirects]
  end

  private

  def redirect_params
    params.require(:redirect).permit(
      :to_path,
      :from_path,
    )
  end
end
