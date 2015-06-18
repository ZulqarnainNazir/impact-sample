module ConnectHelper
  def cce_connect_url(cce_url, cce_id)
    token = ConnectToken.encode(id: cce_id)
    uri = URI(cce_url + '/session')
    uri.query = URI.encode_www_form({ token: token })
    uri.to_s
  end
end
