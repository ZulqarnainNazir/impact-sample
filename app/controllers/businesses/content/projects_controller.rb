class Businesses::Content::ProjectsController < Businesses::Content::BaseController
  include PlacementAttributesConcern

  before_action only: new_actions do
    @project = @business.projects.new
  end

  before_action only: member_actions do
    @project = @business.projects.find(params[:id])
  end

  def create
    create_resource @project, project_params, location: [@business, :content_feed]
  end

  def update
    update_resource @project, project_params, location: [@business, :content_feed]
  end

  def destroy
    destroy_resource @project, location: [@business, :content_feed]
  end

  private

  def project_params
    params.require(:project).permit(
      :title,
      :description,
      project_images_attributes: [
        :id,
        :description,
        :_destroy,
        project_image_placement_attributes: placement_attributes,
      ],
    ).tap do |safe_params|
      merge_placement_image_attributes_array safe_params[:project_images_attributes], :project_image_placement_attributes
      if safe_params[:project_images_attributes]
        safe_params[:project_images_attributes].each do |_, attr|
          attr.merge! project: @project
        end
      end
    end
  end
end
