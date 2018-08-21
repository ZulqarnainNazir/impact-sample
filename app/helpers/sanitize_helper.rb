module SanitizeHelper
  def sanitize(html)
    Sanitize.fragment(html.to_s, Sanitize::Config::DEFAULT).html_safe
  end

  def sanitize_html(html)
    Sanitize.fragment(html.to_s, Sanitize::Config.merge(Sanitize::Config::RELAXED,
      attributes: {
        'a' => Sanitize::Config::RELAXED[:attributes]['a'] + ['target'],
      },
    )).html_safe
  end

  def sanitize_simple(html)
    Nokogiri::HTML.parse(Sanitize.fragment(html.to_s, Sanitize::Config::DEFAULT).html_safe).text
  end
end
