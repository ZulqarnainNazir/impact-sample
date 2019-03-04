class Businesses::Content::JobsController < Businesses::Content::BaseController
  include PlacementAttributesConcern

  before_action only: new_actions do
    @job = @business.jobs.new
  end

  before_action only: member_actions do
    @job = @business.jobs.find(params[:id])
  end

  def clone
    cloned_post = @business.jobs.find(params[:id])
    cloned_attributes = cloned_post.attributes.slice(*cloneable_attributes)
    @job = @business.jobs.new(cloned_attributes)
    @job.content_category_ids = cloned_post.content_category_ids
    @job.content_tag_ids = cloned_post.content_tag_ids
    @job.job_image_placement_attributes = { image_id: cloned_post.job_image.try(:id) }
    render :new
  end

  def create
    @job = Job.new(job_params)
    @job.business = @business

    if params[:draft].present?
      @job.published_status = false
    else
      @job.published_status = true
    end
    respond_to do |format|
      if @job.save
        # flash[:appcues_event] = "Appcues.track('created job')"
        @job.__elasticsearch__.index_document
        flash[:notice] = 'Job successfully created.'
        format.html { redirect_to edit_business_content_job_path(@business, @job), notice: "Draft job saved" } if params[:draft].present?
        format.html { redirect_to edit_business_content_job_path(@business, @job), notice: "Job created successfully" } if !params[:draft].present?
      else
        flash[:notice] = 'Something went wrong - please try again.'
        format.html { render :action => "new" }
      end
    end
    intercom_event 'created-job'
  end

  def update
    if !params[:job][:virtual_event].present?
      @job.virtual_event = false
    end
    if params[:job][:job_location_attributes][:location_id].empty? && @job.job_location.present?
      params[:job][:job_location_attributes][:location_id] = @job.job_location.location_id
    end

    if params[:draft].present?
      @job.published_status = false
    else
      @job.published_status = true
    end
    respond_to do |format|
      if @job.update(job_params)
        #@job.reschedule_events!
        @job.__elasticsearch__.index_document
        flash[:notice] = 'Job was successfully updated.'

        format.html { redirect_to edit_business_content_job_path(@business, @job), notice: "Draft updated." } if params[:draft].present?
        format.html { redirect_to edit_business_content_job_path(@business, @job) } if !params[:draft].present?

      else
        flash[:notice] = 'Something went wrong - please try again.'
        format.html { render :action => "edit" }
      end
    end
  end


  def edit
    port = ":#{request.try(:port)}" if request.port
    post_path = website_job_path
    @preview_url = @job.published_status != false ? @business.website.host + port + post_path : [:website, :generic_post, :preview, :type => "jobs", only_path: false, :host => @business.website.host, protocol: :http, :id => @job.id]
  end

  def destroy
    destroy_resource @job, location: [@business, :content_root] do |success|
      if success
        Job.__elasticsearch__.refresh_index!
      end
    end
  end

  def sharing_insights
    @job = Job.find(params[:job_id])
    @graph = FacebookAnalytics.new(facebook_token: @business.facebook_token)
  end

  private

  def cloneable_attributes
      %w[title subtitle description start_date compensation_type
        compensation_range end_date schedule_type kind meta_description url
        hide_full_address show_city_only private rsvp_required]
  end

  def job_params
    params.require(:job).permit(
      :title,
      :subtitle,
      :description,
      :start_date,
      :compensation_type,
      :compensation_range,
      :end_date,
      :schedule_type,
      :kind,
      :meta_description,
      :url,
      :hide_full_address,
      :show_city_only,
      :private,
      :virtual_event,
      :rsvp_required,
      content_category_ids: [],
      content_tag_ids: [],
      job_location_attributes: [:id, :location_id],
      job_image_placement_attributes: placement_attributes,
      main_image_placement_attributes: placement_attributes,
    ).tap do |safe_params|
      merge_placement_image_attributes safe_params, :job_image_placement_attributes
      merge_placement_image_attributes safe_params, :main_image_placement_attributes
      safe_params[:content_category_ids] = [] unless safe_params[:content_category_ids]
      safe_params[:content_tag_ids] = [] unless safe_params[:content_tag_ids]
    end
  end
end
