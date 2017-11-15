class Website::JobsController < Website::BaseController
  def index
    @show_location = false
    @jobs = @business.jobs.
      where('start_date >= ?', Time.zone.now).
      order(start_date: :asc).
      page(params[:page]).
      per(20)
  end
  def show
    @show_location = true
    @job = @business.jobs.find(params[:id])
    # This redirect is used by events to show a url like http://mybusiness.impact.dev:5000/2017/10/18/3/this-job-is-a-draft/
    # the redirect will work here, but the target page has not been wired up so it returns a 404

    #generic_params = @job.to_generic_param
    #if params[:uuid] =~ /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/
    #  generic_params[:uuid] = params[:uuid]
    #end
    #redirect_to website_generic_post_path(generic_params), status: 301
  end
end
