class Website::BaseController < ApplicationController
  layout 'website'

  before_action do
    @webhost = Webhost.find_by_name(request.host)

    if @webhost && @webhost.website
      @website = @webhost.website
    elsif !@webhost && request.host.match(Rails.application.secrets.host)
      @website = Website.find_by_subdomain(request.subdomains.first)
    end

    if !@website
      raise ActiveRecord::RecordNotFound
    elsif @webhost != @website.webhost
      redirect_to host: @website.webhost.name
    else
      @business = @website.business
      @location = @business.location
    end
  end
end
