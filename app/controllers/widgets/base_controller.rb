class Widgets::BaseController < ApplicationController
  after_action :allow_iframe
  layout "website_embed"
  def index
  end

  private
  def allow_iframe
    response.headers.except! 'X-Frame-Options'
  end
end
