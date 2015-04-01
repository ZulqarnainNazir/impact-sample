class Businesses::Data::TeamMembersController < Businesses::BaseController
  before_action only: new_actions do
    @team_member = @business.team_members.new
  end

  before_action only: member_actions do
    @team_member = @business.team_members.find(params[:id])
  end

  def index
    @team_members = @business.team_members
  end

  def create
    create_resource @team_member, team_member_params.merge(position: @business.team_members.count), location: [@business, :data_team_members]
  end

  def update
    update_resource @team_member, team_member_params, location: [@business, :data_team_members]
  end

  def destroy
    destroy_resource [@business, :data, @team_member]
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
