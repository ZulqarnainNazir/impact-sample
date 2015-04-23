class Website::BeforeAftersController < Website::BaseController
  def show
    @before_after = @business.before_afters.find(params[:id])
  end
end
