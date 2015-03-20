class Onboard::Website::BaseController < ApplicationController
  before_action :authenticate_user!
  layout 'onboard_website'
end
