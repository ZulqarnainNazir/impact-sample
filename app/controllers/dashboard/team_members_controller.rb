class Dashboard::TeamMembersController < Dashboard::BaseController
  before_action only: new_actions do
    @team_member = @business.team_members.new
  end

  before_action only: member_actions do
    @team_member = @business.team_members.find(params[:id])
  end

  def index
    @team_members = @business.team_members.alphabetical
  end

  def create
    create_resource [@business, @team_member], team_member_params, location: [@business, :team_members]
  end

  def update
    update_resource [@business, @team_member], team_member_params, location: [@business, :team_members]
  end

  def destroy
    destroy_resource [@business, @team_member]
  end

  private

  def team_member_params
    params.require(:team_member).permit(
      :first_name,
      :last_name,
      :email,
      :title,
      :description,
      :facebook_id,
      :google_plus_id,
      :linkedin_id,
      :twitter_id,
      team_member_profile_placement_attributes: [
        :id,
        :_destroy,
        image_attributes: [
          :id,
          :alt,
          :title,
          :attachment_cache_url,
          :attachment_content_type,
          :attachment_file_name,
          :attachment_file_size,
          :_destroy,
        ],
      ],
    ).deep_merge(
      team_member_profile_placement_attributes: {
        image_attributes: {
          user: current_user,
          business: @business,
        },
      },
    )
  end
end
