class Subdomain
  def self.available(subdomain)
    subdomain = subdomain.gsub(/'/, '').parameterize[0..26]

    if Website.exists?(subdomain: subdomain)
      n = 1
      while Website.exists?(subdomain: "#{subdomain}-#{n}") do
        n += 1
      end
      "#{subdomain}-#{n}"
    else
      subdomain
    end
  end
end
