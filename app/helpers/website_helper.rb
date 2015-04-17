module WebsiteHelper
  def website_host(website)
    if website.webhost.try(:primary?)
      website.webhost.name
    else
      [website.subdomain, Rails.application.secrets.host].join('.')
    end
  end
end
