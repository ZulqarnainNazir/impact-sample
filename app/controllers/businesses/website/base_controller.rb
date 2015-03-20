class Businesses::Website::BaseController < Businesses::BaseController
  before_action do
    @website = @business.website

    unless @website
      redirect_to @business
    end
  end
end
