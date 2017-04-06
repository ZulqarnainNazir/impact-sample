class BaseApiController < ActionController::Base
  # protect_from_forgery with: :null_session, :if => Proc.new { |c| c.request.format == 'application/json'}
  protect_from_forgery with: :null_session
  respond_to :json

end