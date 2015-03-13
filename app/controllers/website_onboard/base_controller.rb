class WebsiteOnboard::BaseController < ApplicationController
  before_action :authenticate_user!
  layout 'website_onboard'
end
