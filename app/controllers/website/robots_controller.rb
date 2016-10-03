class Website::RobotsController < Website::BaseController

  def txt
    respond_to :text
    expires_in 6.hours, public: true
    # render 'views/website/robots/txt.text.slim'
  end
end
