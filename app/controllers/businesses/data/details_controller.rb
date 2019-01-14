class Businesses::Data::DetailsController < Businesses::BaseController
  include PlacementAttributesConcern

  before_action only: %i[create update] do
    params[:business][:category_ids].reject!(&:blank?) rescue nil
  end

  def update
    update_resource @business, business_params, context: :requires_categories, location: [:edit, @business, :data_details]

    respond_to do |format|
      if @business.save
        # format.html { redirect_to tasks_url, notice: 'Task was successfully created. '+task_params.inspect}

        # format.json { render :show, status: :created, location: @business }
        format.json {render json: { text: 'Ok' }}
      else
        # format.html { render :new }
        # format.json { render json: @business.errors, status: :unprocessable_entity }
        format.json { render text: 'Error', status: 422 }
      end
    end


    # if @business.update_attributes(:community_id)
    #   render json: { text: 'Ok' }
    # else
    #   render text: 'Error', status: 422
    # end

  end

  private

  def business_params
    params.require(:business).permit(
    # params.permit(
      # :business,
      :description,
      :kind,
      :name,
      :tagline,
      :website_url,
      :year_founded,
      :membership_org,
      category_ids: [],
      logo_placement_attributes: placement_attributes,
      hero_placement_attributes: placement_attributes,
    ).deep_merge(
      logo_placement_attributes: {
        image_user: current_user,
        image_business: @business,
      },
      hero_placement_attributes: {
        image_user: current_user,
        image_business: @business,
      },
    )
  end
end
