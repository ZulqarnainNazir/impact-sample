class Connect::CcesController < ApplicationController
  before_action :authenticate_user!

  def redirect
    token = ConnectToken.encode(id: current_user.cce_id)
    uri = URI(current_user.cce_url + '/session_create')
    uri.query = URI.encode_www_form({ token: token })
    redirect_to uri.to_s
  end
end
