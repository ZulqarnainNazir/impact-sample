module SanitizeHelper
  def sanitize_html(html)
    Sanitize.fragment(html.to_s, Sanitize::Config.merge(Sanitize::Config::RELAXED,
      attributes: {
        'a' => Sanitize::Config::RELAXED[:attributes]['a'] + ['target'],
      },
    )).html_safe
  end
end
