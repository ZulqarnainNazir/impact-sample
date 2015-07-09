class Connect::SessionRedirectsController < ApplicationController
  before_action :authenticate_user!

  def locable
    token = ConnectToken.encode(id: current_user.cce_id)
    uri = URI(current_user.cce_url + '/receive_impact')
    uri.query = URI.encode_www_form({ token: token })
    redirect_to uri.to_s
  end
end
