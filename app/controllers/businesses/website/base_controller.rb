class Businesses::Website::BaseController < Businesses::BaseController
  before_action do
    @website = @business.website
    # only temporary. it's better to do this work once and store in DB rather than re-parse custom
    # CSS for every request
    custom_css = Crass.parse(@website.custom_css)
    # raise StandardError, custom_css
    selectors = []
    custom_css.map! do |n|
      if n[:node] == :style_rule
        # raise StandardError, Crass::Parser.stringify(n)
        # raise StandardError, Crass::Parser.stringify(n[:selector][:tokens])
        # tokens = n[:selector][:tokens].map { |e| Crass::Parser.stringify(e) }
        tokens = Crass::Parser.stringify(n[:selector][:tokens]).split(' ')
        # raise StandardError, tokens.join('')
        tokens.insert(0, ".browser-panel")
        tokens.insert(-2, "*:not(.exclude-custom-css) >")
        selectors << tokens
        css = "#{tokens.join(" ")} {#{Crass::Parser.stringify(n[:children])}"
        # css = ".browser-panel *:not(.exclude-custom-css) > #{Crass::Parser.stringify(n[:selector])} { #{Crass::Parser.stringify(n[:children])} }"
        Crass.parse(css).first
      else
        n
      end
    end

    # raise StandardError, Crass::Parser.stringify(custom_css)
    # raise StandardError, selectors
    @custom_css = Crass::Parser.stringify(custom_css)
    unless @website
      redirect_to @business
    end
  end
end
