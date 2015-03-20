class Onboard::Website::BusinessesController < Onboard::Website::BaseController
  before_action only: new_actions do
    @business = Business.new
  end

  before_action only: member_actions do
    @business = current_user.businesses.find(params[:id])
  end

  before_action only: %i[create update] do
    params[:business][:category_ids].reject!(&:blank?) rescue nil
  end

  def create
    create_resource @business, business_params, location: [:edit_onboard_website, @business, :location]
  end

  def update
    update_resource @business, business_params, location: [:edit_onboard_website, @business, :location]
  end

  def destroy
    @business.destroy!
    redirect_to :new_onboard_website_business, notice: 'Ok, we’ve removed your business.'
  end

  private

  def business_params
    params.require(:business).permit(
      :description,
      :kind,
      :name,
      :tagline,
      :website_url,
      :year_founded,
      category_ids: [],
    ).deep_merge(
      owners: [current_user],
    )
  end
end
