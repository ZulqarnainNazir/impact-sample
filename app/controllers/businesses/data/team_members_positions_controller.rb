class Businesses::Data::TeamMembersPositionsController < Businesses::BaseController
  before_action do
    @team_members = @business.team_members
  end

  def update
    reorder_resources @team_members, params[:team_members_positions], location: [@business, :data_team_members] do |success|
      render 'business/data/team_members/index' unless success
    end
  end
end
