class Businesses::Content::BeforeAftersController < Businesses::Content::BaseController
  include PlacementAttributesConcern
  include RequiresWebPlanConcern

  before_action only: new_actions do
    @before_after = @business.before_afters.new
  end

  before_action only: member_actions do
    @before_after = @business.before_afters.find(params[:id])
  end

  def create
    @before_after = BeforeAfter.new(before_after_params)
    @before_after.business = @business
    if params[:draft].present?
      @before_after.published_status = false
    else
      @before_after.published_status = true
    end

    respond_to do |format|
      if @before_after.save
        # flash[:appcues_event] = "Appcues.track('created before & after')"
        @before_after.__elasticsearch__.index_document
        flash[:notice] = 'Before/After post was successfully created.'
        format.html { redirect_to edit_business_content_before_after_path(@business, @before_after), notice: "Before/After post created successfully" } if params[:draft].present?
        format.html { redirect_to edit_business_content_before_after_path(@business, @before_after), notice: "Post created successfully" } if !params[:draft].present?
      else
        flash[:notice] = 'Something went wrong - please try again.'
        format.html { render :action => "new" }
      end
    end

    #BeforeAfter.__elasticsearch__.refresh_index!
    intercom_event 'created-before-after'
  end

  def edit
    port = ":#{request.try(:port)}" if request.port
    post_path = website_before_after_path(@before_after)
    @preview_url = @before_after.published_status != false ? @business.website.host + port + post_path : [:website, :generic_post, :preview, :type => "before_afters", only_path: false, :host => @business.website.host, protocol: :http, :id => @before_after.id]
  end


  def update
    if params[:draft].present?
      @before_after.published_status = false
    else
       @before_after.published_status = true
    end
    respond_to do |format|
      if @before_after.update(before_after_params)
        @before_after.__elasticsearch__.index_document
        flash[:notice] = 'Post was successfully updated.'
        format.html { redirect_to edit_business_content_before_after_path(@business, @before_after), notice: "Draft updated." } if params[:draft].present?
        format.html { redirect_to edit_business_content_before_after_path(@business, @before_after) } if !params[:draft].present?
      else
        flash[:notice] = 'Something went wrong - please try again.'
        format.html { render :action => "edit" }
      end
    end
    #@before_after.__elasticsearch__.index_document
    #eforeAfter.__elasticsearch__.refresh_index!
  end

  def destroy
    destroy_resource @before_after, location: [@business, :content_root] do |success|
      if success
        BeforeAfter.__elasticsearch__.refresh_index!
      end
    end
  end

  def sharing_insights
    @before_after = BeforeAfter.find(params[:before_after_id])
    @graph = FacebookAnalytics.new(facebook_token: @business.facebook_token)
  end

  private

  def before_after_params
    params.require(:before_after).permit(
      :description,
      :meta_description,
      :published_on,
      :published_time,
      :title,
      content_category_ids: [],
      content_tag_ids: [],
      after_image_placement_attributes: placement_attributes,
      before_image_placement_attributes: placement_attributes,
      main_image_placement_attributes: placement_attributes,
    ).deep_merge(
      after_image_placement_attributes: {
        image_user: current_user,
        image_business: @business,
      },
      before_image_placement_attributes: {
        image_user: current_user,
        image_business: @business,
      },
      main_image_placement_attributes: {
        image_user: current_user,
        image_business: @business,
      },
    ).tap do |safe_params|
      safe_params[:content_category_ids] = [] unless safe_params[:content_category_ids]
      safe_params[:content_tag_ids] = [] unless safe_params[:content_tag_ids]
    end
  end
end
