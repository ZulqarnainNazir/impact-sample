class Businesses::Crm::ContactMessageNotificationsController < Businesses::BaseController
  def update
    Authorization.update authorizations_params.keys, authorizations_params.values
    redirect_to [:edit, @business, :crm_contact_message_notifications], notice: t('.notice')
  end

  private

  def authorizations_params
    params[:authorizations].kind_of?(Hash) ? params[:authorizations] : {}
  end
end
