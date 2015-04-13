class BusinessesController < ApplicationController
  before_action :authenticate_user!

  def index
    @businesses = current_user.authorized_businesses.alphabetical
  end
end
