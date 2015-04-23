class Website::ProjectsController < Website::BaseController
  def show
    @project = @business.projects.find(params[:id])
  end
end
