class Businesses::DashboardTourViewedsController < Businesses::BaseController
  def create
    current_user.update viewed_dashboard_tour: true
    render text: 'ok'
  end
end
