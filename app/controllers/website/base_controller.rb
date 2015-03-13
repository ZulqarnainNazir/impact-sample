class Website::BaseController < ApplicationController
  layout 'website'

  before_action do
    @website = Website.find_by_subdomain!(request.subdomains.first)
    @business = @website.business
    @location = @business.location
  end
end
