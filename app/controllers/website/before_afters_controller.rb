class Website::BeforeAftersController < Website::BaseController
  def show
    @before_after = @business.before_afters.find(params[:id])
    redirect_to website_generic_post_path(@before_after.to_generic_param), status: 301
  end
end
