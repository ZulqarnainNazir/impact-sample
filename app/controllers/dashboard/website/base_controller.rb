class Dashboard::Website::BaseController < Dashboard::BaseController
  before_action do
    @website = @business.website

    unless @website
      redirect_to @business
    end
  end
end
