class Website::CustomPagesController < Website::BaseController
  before_action do
    @page = @website.webpages.custom.find_by_pathname!(params[:id])
  end
end
