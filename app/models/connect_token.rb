module ConnectToken
  def self.encode(payload)
    JSON::JWT.new(payload.merge(exp: exp)).sign(ENV['CONNECT_KEY']).encrypt(private_key.public_key).to_s
  end

  def self.decode(token)
    JSON::JWT.decode(token, private_key).with_indifferent_access
  end

  private

  def self.exp
    Time.now + 10.seconds
  end

  def self.private_key
    OpenSSL::PKey::RSA.new(ENV['CONNECT_PRIVATE_KEY'])
  end
end
