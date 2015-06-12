module WebsiteHelper
  def website_host(website)
    if website.webhost.try(:primary?)
      website.webhost.name
    else
      [website.subdomain, Rails.application.secrets.host].join('.')
    end
  end

  def webpage_container(&block)
    content_tag :div, class: 'webpage-wrapper' do
      content_tag :div, class: 'container' do
        content_tag :div, class: ['webpage-container', @website.try(:wrap_container) == 'true' ? 'webpage-container-wrapper' : nil].reject(&:nil?).join(' '), &block
      end
    end
  end
end
