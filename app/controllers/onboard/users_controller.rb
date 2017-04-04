class Onboard::UsersController < ApplicationController
  def new
    query = params[:query].to_s.strip
    if query.present?
      @businesses = Business.where("name ILIKE ?", "%#{query}%").limit(6)
    else
      @businesses = Business.all.limit(6)
    end
    @categories = Category.alphabetical

    respond_to do |format|
      format.html
      format.json { render json: @businesses.as_json(include: [:location, :categories, :owners]) }
    end
  end

  def create

    # Process params to create (or update exisitng) Business and assoiciate it with the user, and
    # create a new subscription plan associated with both.

    # The request is coming in as JSON via AJAX, so if you want to redirect to another location on
    # success, render json with the location key set to a url string, which the JavaScript will then
    # automatically redirect to. eg:
    render json: {
      :location => "/businesses/#{params[:business][:id]}"
    }
  end
end
