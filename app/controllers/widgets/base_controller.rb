# require 'search_helper'
class Widgets::BaseController < ApplicationController

  include ContentSearchConcern
  include EventSearchConcern

  layout "website_embed"

  before_action do
    @masonry = true
  end

  after_action :allow_iframe

  def index
  end

  private

  def allow_iframe
    response.headers.except! 'X-Frame-Options'
  end
end
