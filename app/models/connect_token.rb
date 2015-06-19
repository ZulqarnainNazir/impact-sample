module ConnectToken
  def self.encode(payload)
    JSON::JWT.new(payload.merge(exp: exp.to_i)).sign(ENV['CONNECT_KEY']).encrypt(private_key.public_key).to_s
  end

  def self.decode(token)
    verify JSON::JWT.decode(token, private_key).with_indifferent_access
  end

  private

  def self.exp
    Time.now + 10.seconds
  end

  def self.private_key
    OpenSSL::PKey::RSA.new(ENV['CONNECT_PRIVATE_KEY'])
  end

  def self.verify(payload)
    current_time = Time.now
    expiration_time = Time.at(payload[:exp])
    issued_time = expiration_time - 10.seconds

    if current_time > issued_time && current_time < expiration_time
      payload
    else
      {}
    end
  end
end
