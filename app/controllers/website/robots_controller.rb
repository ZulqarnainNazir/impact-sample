class Website::RobotsController < Website::BaseController

  def txt
    if current_user
      robots = File.read(Rails.root + "public/robots.#{Rails.env}.txt")
      render :text => robots, :layout => false, :content_type => "text/plain"
    end
    respond_to :text
    expires_in 6.hours, public: true
    # render 'views/website/robots/txt.text.slim'
  end
end
