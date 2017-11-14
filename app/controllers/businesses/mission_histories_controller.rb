class Businesses::MissionHistoriesController < Businesses::BaseController
  def index
    @histories = MissionHistory.for_business(@business).order('happened_at DESC')
  end
end
