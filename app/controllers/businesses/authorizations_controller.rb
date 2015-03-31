class Businesses::AuthorizationsController < Businesses::BaseController
  before_action only: new_actions do
    @authorization = @business.authorizations.new
  end

  before_action only: member_actions do
    @authorization = @business.authorizations.find(params[:id])
  end

  before_action only: :destroy do
    if @authorization.user == current_user
      redirect_to [@business, :authorizations], alert: 'You cannot remove yourself.'
    end
  end

  def index
    @authorizations = @business.authorizations.alphabetical
  end

  def create
    create_resource [@business, @authorization], authorization_params, context: :invite, location: [@business, :authorizations]
  end

  def destroy
    destroy_resource [@business, @authorization]
  end

  private

  def authorization_params
    params.require(:authorization).permit(
      :role,
      user_attributes: [
        :first_name,
        :last_name,
        :email,
      ],
    )
  end
end
