class Businesses::Website::PublicationsController < Businesses::Website::BaseController
  include RequiresWebPlanConcern

  before_action do
    @webpage = @website.webpages.find(params[:webpage_id])
  end

  def create
    if params[:clone]
      if @cloned_page = @webpage.clone!
        flash[:notice] = "#{@webpage.title} has been cloned successfully"
        redirect_to edit_business_website_custom_page_url(@business.id, @cloned_page.id )
        return
      else
        flash[:notice] = @cloned_page.errors&.full_messages&.to_sentence
        redirect_to :back
      end
    else
      toggle_resource_boolean_on @webpage, :active, location: [@business, :website_webpages]
    end
  end

  def destroy
    toggle_resource_boolean_off @webpage, :active, location: [@business, :website_webpages]
  end
end
