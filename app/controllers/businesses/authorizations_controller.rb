class Businesses::AuthorizationsController < Businesses::BaseController
  before_action do
    unless current_user.super_user? || current_user.authorizations.where(business_id: @business.id, role: 0).any?
      redirect_to [@business, :dashboard], alert: 'You are not authorized to manage that information.'
    end
  end

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

  def update
    @authorization.user.resend_confirmation_instructions
    # AuthorizationsMailer.owner_welcome(@authorization).deliver_now
    redirect_to [@business, :authorizations]
  end

  def destroy
    destroy_resource [@business, @authorization]
  end

  private

  def authorization_params
    params.require(:authorization).permit(
      :role,
      :invite_message,
      user_attributes: [
        :first_name,
        :last_name,
        :email,
      ],
    )
  end
end
