class Businesses::Content::BaseController < Businesses::BaseController
  # before_action :confirm_content_activated, except: [:index]
  include ActionView::Helpers::TextHelper

  # def confirm_content_activated
  #   confirm_module_activated(1)
  # end
  #
  # def index
  #   if !@business.module_active?(1)
  #     messages = AccountModule.create_module(@business.id, {kind: 1, active: true})
  #     @business.reload
  #     # flash[:appcues_event] = messages[0]
  #     flash[:notice] = messages[1]
  #   end
  #   redirect_to edit_business_account_module_path(@business, @business.get_account_module(1).id)
  # end
end
