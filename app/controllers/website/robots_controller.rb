class Website::RobotsController < Website::BaseController

  def txt
    # if current_user
    #   robots = File.read(Rails.root + "public/robots.admin.txt")
    #   render :text => robots, :layout => false, :content_type => "text/plain"
    # end
    render 'robots.text.erb'
    expires_in 6.hours, public: true
    # expires_in 5.minutes, public: true
  end
end
