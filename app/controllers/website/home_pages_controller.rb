class Website::HomePagesController < Website::BaseController
  before_action do
    @page = @website.home_page or raise ActiveRecord::RecordNotFound
  end
end
